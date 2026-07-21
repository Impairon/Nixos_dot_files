return function(config)
    -- Load configuration variables passed from main config
    local mainMod = config.mainMod or "SUPER"                 -- Main modifier key (Windows/Super)
    local terminal = config.terminal or "kitty"               -- Default terminal emulator
    local fileManager = config.fileManager or "kitty -e yazi" -- File manager


    ------------------------------
    -- APPLICATION LAUNCHERS --
    ------------------------------
    --- Lauch Notification Center
    hl.bind("ALT + N", hl.dsp.exec_cmd("swaync-client --toggle-panel"))

    -- Launch terminal with Alt+K
    hl.bind("ALT + K", hl.dsp.exec_cmd(terminal))

    -- Launch Brave
    hl.bind("ALT + B", hl.dsp.exec_cmd("brave"))

    -- screen shots
    hl.bind("ALT + S", hl.dsp.exec_cmd("~/.config/rofi/hyprshot/hyprshot.sh"))
    -- Close current window with Super+Z
    hl.bind(mainMod .. " + Z", hl.dsp.window.close())

    -- Exit Hyprland / Shutdown with Super+M
    hl.bind(mainMod .. " + M",
        hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

    -- Launch file manager with Super+E
    hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

    -- Launch rofimoji
    hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("pkill rofimoji || rofimoji"))

    -- Toggle floating window with Super+Space
    -- ⚠️ CONFLICT POTENTIAL: This may conflict with app launchers that also use Super+Space
    hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))

    -- Launch application menu (rofi) with Super+F
    -- Kills existing rofi first to prevent multiple instances
    hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))

    -- Lauch hyprlock and lock the Screen
    hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
    hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("systemctl suspend && hyprlock"))

    -- Toggle pseudo-tiling mode with Super+P
    hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

    -- Toggle split orientation (dwindle layout only) with Super+J
    hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
    -- lauch Clibboard
    hl.bind(mainMod .. " +v", hl.dsp.exec_cmd("pkill rofi ||cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

    --Change Language
    hl.bind("ALT + L", hl.dsp.exec_cmd("hyprctl switchxkblayout at-translated-set-2-keyboard next"))

    -- Call lowery
    hl.bind("ALT + H", hl.dsp.exec_cmd("cd ~/codes/python && ~/codes/python/lowery.sh"))
    ------------------------------
    -- WINDOW FOCUS NAVIGATION --
    ------------------------------
    -- Vim-style window navigation (A=Left, D=Right, W=Up, S=Down)

    -- Focus left window with Super+A
    hl.bind(mainMod .. " + A", hl.dsp.focus({ direction = "left" }))

    -- Focus right window with Super+D
    hl.bind(mainMod .. " + D", hl.dsp.focus({ direction = "right" }))

    -- Focus window above with Super+W
    hl.bind(mainMod .. " + W", hl.dsp.focus({ direction = "up" }))

    -- Focus window below with Super+S
    hl.bind(mainMod .. " + S", hl.dsp.focus({ direction = "down" }))

    ------------------------------
    -- WINDOW RESIZING --
    ------------------------------
    -- Increase width
    hl.bind("ALT + SHIFT + D", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })

    -- Decrease width
    hl.bind("ALT + SHIFT + A", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })

    -- Increase height
    hl.bind("ALT + SHIFT + S", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

    -- Decrease height
    hl.bind("ALT + SHIFT + W", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })

    -----------------------------
    --- Swap Windows --
    -----------------------------
    --- Move left
    hl.bind("SUPER + SHIFT + D", hl.dsp.window.swap({ direction = "r" }))
    --- Move left
    hl.bind("SUPER + SHIFT + A", hl.dsp.window.swap({ direction = "l" }))
    --- Move left
    hl.bind("SUPER + SHIFT + w", hl.dsp.window.swap({ direction = "u" }))
    --- Move left
    hl.bind("SUPER + SHIFT + s", hl.dsp.window.swap({ direction = "d" }))

    ------------------------------
    -- WORKSPACE SWITCHING --
    ------------------------------

    -- Switch workspaces with Super+[0-9]
    -- Move active window to a workspace with Super+Shift+[0-9]
    for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end

    ------------------------------
    -- SPECIAL WORKSPACE (SCRATCHPAD) --
    ------------------------------

    -- Toggle special 'magic' scratchpad workspace with Super+H
    hl.bind(mainMod .. " + H", hl.dsp.workspace.toggle_special("magic"))

    -- Move current window to special workspace with Super+Shift+H
    hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ workspace = "special:magic" }))

    ------------------------------
    -- WORKSPACE SCROLLING --
    ------------------------------

    -- Scroll through existing workspaces with Super+mouse wheel
    -- ⚠️ CONFLICT POTENTIAL: These may conflict with apps that expect Super+scroll for zoom or other functions
    hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

    ------------------------------
    -- MOUSE INTERACTIONS --
    ------------------------------

    -- Move windows with Super+LeftMouseButton (mouse:272 = left click)
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

    -- Resize windows with Super+RightMouseButton (mouse:273 = right click)
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    ------------------------------
    -- MEDIA & MULTIMEDIA KEYS --
    ------------------------------

    -- Volume controls (requires wireplumber/pipewire)
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
        { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
        { locked = true, repeating = true })
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
        { locked = true, repeating = true })
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
        { locked = true, repeating = true })

    -- Screen brightness controls (requires brightnessctl)
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
        { locked = true, repeating = true })

    -- Media player controls (requires playerctl)
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

    -------------------------
    --- Language switch --
    -------------------------
    --- press the two shifts
end
