#!/usr/bin/env bash

COLORSCHEME=Catppuccin

### WAYLAND ENV ###
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=qtile
export XDG_SESSION_DESKTOP=qtile
export QT_QPA_PLATFORM=wayland;xcb
export QT_QPA_PLATFORMTHEME=qt6ct
export GDK_BACKEND=wayland,x11
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1
export CLUTTER_BACKEND=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

### AUTOSTART PROGRAMS ###
fcitx5 -d &
wl-paste --watch cliphist store &
nm-applet &
udiskie &
dunst &
syncthing --no-browser &
# pamac-tray-icon-plasma
# birdtray &
# cbatticon &

# Idle handling + screen lock (replaces xss-lock + i3lock)
swayidle -w \
  timeout 300 'swaylock -f -i ~/.config/qtile/lock' \
  before-sleep 'swaylock -f -i ~/.config/qtile/lock' &

# dockd --daemon &  # X11-only, no Wayland port available - dropped

# Multi-monitor setup (replaces xrandr). Adjust modes/positions for your actual
# panel resolution - wlr-randr requires WIDTHxHEIGHT, not just WIDTH.
if [[ $(< /sys/class/drm/card1-HDMI-A-2/status) = "connected" ]]; then
  wlr-randr \
    --output eDP-1 --pos 0,0 --transform normal \
    --output HDMI-2 --pos 1920,0 --mode 1920x1080 --transform normal \
    --output VGA-1 --off \
    --output HDMI-1 --off \
    --output DP-1 --off \
    --output HDMI-3 --off \
    --output DP-2 --off \
    --output DP-3 --off
fi

### UNCOMMENT ONLY ONE OF THE FOLLOWING THREE OPTIONS! ###
# 1. Uncomment to restore last saved wallpaper
# 2. Uncomment to set a random wallpaper on login
# find /path/to/wallpaper/folders -type f | shuf -n 1 | xargs -I{} swaybg -i {} -m fill &
swaybg --output HDMI-2 --image ~/.config/qtile/wall1 --mode fill &
swaybg --output eDP-1 --image ~/.config/qtile/wall2 --mode fill &
# 3. Uncomment to set wallpaper with nitrogen (X11 only, no Wayland equivalent needed with swaybg above)
#
