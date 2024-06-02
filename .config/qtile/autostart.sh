#!/usr/bin/env bash 

COLORSCHEME=Catppuccin


### AUTOSTART PROGRAMS ###
#/bin/bash -c  "sleep 1; /usr/bin/xmodmap /home/zeus/.config/x11/Xmodmap" &
# lxsession &
fcitx5 -d
# copyq &
greenclip daemon &
# nm-applet &
udiskie &
syncthing --no-browser &
# pamac-tray-icon-plasma
# picom &
# birdtray &
# cbatticon &
xrdb -load ~/.config/x11/xresouces
xss-lock -- i3lock -ei ~/.config/qtile/lock &
# xss-lock -- i3lock -B 10 &
# multi.sh
### UNCOMMENT ONLY ONE OF THE FOLLOWING THREE OPTIONS! ###
# 1. Uncomment to restore last saved wallpaper
xwallpaper --zoom ~/.config/qtile/wall &
# 2. Uncomment to set a random wallpaper on login
# find /path/to/wallpaper/folders -type f | shuf -n 1 | xargs xwallpaper --stretch &
# 3. Uncomment to set wallpaper with nitrogen
# nitrogen --restore &
# xrandr --output LVDS-1 --mode 1920x1080 --pos 0x0 --rotate normal --output VGA-1 --off --output HDMI-1 --off --output DP-1 --primary --mode 1920x1080 --pos 1926x0 --rotate normal --output HDMI-2 --off --output HDMI-3 --off --output DP-2 --off --output DP-3 --off
#xrandr --output DP1 --primary --mode 1920x1080 --rate 144.00 --output LVDS1 --mode 1920x1080 --left-of DP1
