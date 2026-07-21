-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
local home = os.getenv("HOME")
hl.on("hyprland.start", function ()
   hl.exec_cmd("sleep 300 && ~/backup.sh")
   hl.exec_cmd("waybar")
   hl.exec_cmd("hypridle")
   hl.exec_cmd("swaync")
   hl.exec_cmd("hyprsunset -t 6500")
   hl.exec_cmd("~/.config/hypr/temp.py")
   hl.exec_cmd("swaybg -i ~/.config/stuff/space.jpg -m fill &")
   hl.exec_cmd("rm -f /home/aboayman/.cache/cliphist/db && wl-paste --watch cliphist store")
   hl.exec_cmd("~/codes/python/eye.sh")
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
end)
