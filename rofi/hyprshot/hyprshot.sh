#!/usr/bin/env bash
set -euo pipefail

# Minimal dependency check (hyprctl added — required for window mode)
for bin in rofi grim slurp satty wl-copy notify-send hyprctl; do
    command -v "$bin" >/dev/null || { notify-send "Screenshot error" "Missing: $bin"; exit 1; }
done

SAVE_DIR="$HOME/Pictures/screenshots"
mkdir -p "$SAVE_DIR"
ROFI_THEME="$HOME/.config/rofi/hyprshot/style.rasi"

selected=$(printf '%s\n' "󰆞  Region" "󱂬  Window" "󰍹  Output" | rofi \
    -dmenu \
    -p "󰹑  Screenshot" \
    -theme "$ROFI_THEME") || exit 0

case "$selected" in
    *Region*) mode="region" ;;
    *Window*) mode="window" ;;
    *Output*) mode="output" ;;
    *) exit 0 ;;
esac

finalpath="$SAVE_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"
tmpfile="$(mktemp /tmp/satty-shot-XXXXXX.png)"
trap 'rm -f "$tmpfile"' EXIT

case "$mode" in
    region)
        if ! geom="$(slurp 2>/dev/null)"; then
            exit 0
        fi
        grim -g "$geom" "$tmpfile"
        ;;

    window)
        # Get plain-text output of active window
        win_info="$(hyprctl activewindow 2>/dev/null || true)"
        if [ -z "$win_info" ]; then
            notify-send "Screenshot error" "No active window found"
            exit 1
        fi

        # Parse geometry using grep and sed.
        # hyprctl outputs "at: X,Y" (no space after comma); coordinates can be
        # negative on multi-monitor setups, so allow an optional '-' and
        # optional whitespace around the comma.
        at_line=$(echo "$win_info" | grep -oE 'at: -?[0-9]+,\s*-?[0-9]+' | head -1)
        size_line=$(echo "$win_info" | grep -oE 'size: [0-9]+,\s*[0-9]+' | head -1)

        if [ -z "$at_line" ] || [ -z "$size_line" ]; then
            notify-send "Screenshot error" "Could not parse window geometry"
            exit 1
        fi

        # Extract numbers (handle optional whitespace and negative X/Y)
        at_x=$(echo "$at_line" | sed -E 's/at: (-?[0-9]+),\s*(-?[0-9]+)/\1/')
        at_y=$(echo "$at_line" | sed -E 's/at: (-?[0-9]+),\s*(-?[0-9]+)/\2/')
        size_x=$(echo "$size_line" | sed -E 's/size: ([0-9]+),\s*([0-9]+)/\1/')
        size_y=$(echo "$size_line" | sed -E 's/size: ([0-9]+),\s*([0-9]+)/\2/')

        # Validate numbers
        if [ -z "$at_x" ] || [ -z "$at_y" ] || [ -z "$size_x" ] || [ -z "$size_y" ] ||
           [ "$size_x" -eq 0 ] || [ "$size_y" -eq 0 ]; then
            notify-send "Screenshot error" "Invalid window geometry (size: $size_x x $size_y)"
            exit 1
        fi

        geom="${at_x},${at_y} ${size_x}x${size_y}"
        grim -g "$geom" "$tmpfile"
        ;;

    output)
        if ! output="$(slurp -o -f "%o" 2>/dev/null)"; then
            exit 0
        fi
        grim -o "$output" "$tmpfile"
        ;;
esac

# Check if capture succeeded
if [ ! -s "$tmpfile" ]; then
    notify-send "Screenshot error" "Failed to capture image"
    exit 1
fi

# Run satty
if satty --filename "$tmpfile" --output-filename "$finalpath" --early-exit 2>/dev/null; then
    if [ -f "$finalpath" ] && [ -s "$finalpath" ]; then
        # Pass MIME type so apps know the clipboard data is a PNG image
        wl-copy --type image/png < "$finalpath"
        notify-send "Screenshot saved" "$mode · $(basename "$finalpath")"
    fi
else
    # satty returned non-zero, check if file was saved anyway
    if [ -f "$finalpath" ] && [ -s "$finalpath" ]; then
        wl-copy --type image/png < "$finalpath"
        notify-send "Screenshot saved" "$mode · $(basename "$finalpath")"
    else
        notify-send "Screenshot cancelled" "Annotation cancelled"
    fi
fi
