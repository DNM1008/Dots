#!/bin/bash
# Deletes legacy GTK1/GTK2 rc files kde-gtk-config regenerates in $HOME,
# since no GTK1/GTK2 apps are installed to read them.
watch_paths=("$HOME" "$HOME/.config")
targets=(".gtkrc" ".gtkrc-2.0" "gtkrc" "gtkrc-2.0")

for f in "${targets[@]}"; do
  rm -f "$HOME/$f" "$HOME/.config/$f" 2>/dev/null
done

inotifywait -m -e create,moved_to --format '%w%f' "${watch_paths[@]}" |
while read -r path; do
  base=$(basename "$path")
  for f in "${targets[@]}"; do
    if [ "$base" = "$f" ]; then
      rm -f "$path"
    fi
  done
done
