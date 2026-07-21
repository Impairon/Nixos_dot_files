#!/usr/bin/env bash
set -euo pipefail

SAVE_DIR="$HOME/Pictures/screenshots"
mkdir -p "$SAVE_DIR"

ROFI_THEME="$HOME/.config/rofi/hyprshot/style.rasi"

if [ -n "${1:-}" ]; then
    # mode passed directly (e.g. from swaync button)
    mode="$1"
else
    # no argument — show rofi picker
    selected=$(printf '%s\n' "󰆞  Region" "󱂬 Window" "󰍹  Output" | rofi \
        -dmenu \
        -p "󰹑  Screenshot" \
        -theme "$ROFI_THEME") || exit 0

    case "$selected" in
        *Region*) mode="region" ;;
        *Window*) mode="window" ;;
        *Output*) mode="output" ;;
        *) exit 0 ;;
    esac
fi

finalpath="$SAVE_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"
tmpfile="$(mktemp /tmp/satty-shot-XXXXXX.png)"
trap 'rm -f "$tmpfile"' EXIT

case "$mode" in
    region)
        geom="$(slurp)" || exit 0
        grim -g "$geom" "$tmpfile"
        ;;
    window)
        grim "$tmpfile"
        ;;
    output)
        grim "$tmpfile"
        ;;
esac

if satty --filename "$tmpfile" --output-filename "$finalpath" --early-exit; then
    if [ -f "$finalpath" ]; then
        wl-copy < "$finalpath"
        notify-send "Screenshot saved" "$mode · $(basename "$finalpath")"
    fi
else
    notify-send "Screenshot cancelled" "Nothing copied to clipboard"
    exit 0
fi
