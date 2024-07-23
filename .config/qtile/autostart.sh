#!/usr/bin/env bash 

COLORSCHEME=Catppuccin


### AUTOSTART PROGRAMS ###
# lxsession &
fcitx5 -d &
# copyq &
greenclip daemon &
# nm-applet &
udiskie &
dunst &
syncthing --no-browser &
# pamac-tray-icon-plasma
# /bin/bash -c  "sleep 1; /usr/bin/xmodmap /home/zeus/.config/x11/Xmodmap" &
# picom &
# birdtray &
# cbatticon &
xrdb -load ~/.config/x11/xresouces
xss-lock -- i3lock -ei ~/.config/qtile/lock &
# xss-lock -- i3lock -B 10 &
# multi.sh
# xrandr --output HDMI-2 --primary --mode 1920x1080  --output LVDS-1 --mode 1920x1080 --below HDMI-2
### UNCOMMENT ONLY ONE OF THE FOLLOWING THREE OPTIONS! ###
# 1. Uncomment to restore last saved wallpaper
xwallpaper --output HDMI-2 --zoom ~/.config/qtile/wall1 --output LVDS-1 --zoom ~/.config/qtile/wall2 &
# 2. Uncomment to set a random wallpaper on login
# find /path/to/wallpaper/folders -type f | shuf -n 1 | xargs xwallpaper --stretch &
# 3. Uncomment to set wallpaper with nitrogen
# nitrogen --restore &
xrandr --output LVDS-1 --mode 1920x1080 --pos 0x1080 --rotate normal --output VGA-1 --off --output HDMI-1 --off --output HDMI-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-3 --off --output DP-2 --off --output DP-3 --off &
qtile cmd-obj -o cmd -f reload_config &
