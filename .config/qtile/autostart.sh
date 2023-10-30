#!/usr/bin/env bash 

COLORSCHEME=Catppuccin


### AUTOSTART PROGRAMS ###
lxsession &
copyq &
nm-applet &
udiskie --tray &
# pamac-tray-icon-plasma &
# picom &
# birdtray &
# cbatticon &
xss-lock -- i3lock -eB 10 &
# xss-lock -- i3lock -B 10 &
xrdb -load ~/.config/xresources
### UNCOMMENT ONLY ONE OF THE FOLLOWING THREE OPTIONS! ###
# 1. Uncomment to restore last saved wallpaper
xwallpaper --stretch ~/.cache/wall &
# 2. Uncomment to set a random wallpaper on login
# find /path/to/wallpaper/folders -type f | shuf -n 1 | xargs xwallpaper --stretch &
# 3. Uncomment to set wallpaper with nitrogen
# nitrogen --restore &

