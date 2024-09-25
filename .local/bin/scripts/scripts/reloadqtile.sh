#!/bin/sh

if [[ $(< /sys/class/drm/card1-HDMI-A-2/status) = "connected" ]]; then
  xrandr --output LVDS-1 --mode 1920x1080 --pos 0x1080 --rotate normal --output VGA-1 --off --output HDMI-1 --off --output HDMI-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-3 --off --output DP-2 --off --output DP-3 --off 
else 
  xrandr --auto
fi
xwallpaper --output HDMI-2 --zoom ~/.config/qtile/wall1 --output LVDS-1 --zoom ~/.config/qtile/wall2 &
# qtile cmd-obj -o cmd -f restart &
qtile cmd-obj -o cmd -f reload_config &
