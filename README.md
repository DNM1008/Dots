# All of my Qtile configurations

Can be installed by the installed script in my repo (incoming)

Install yay first

To install: install all of the necessary software: alacritty, better discord, copyq, dunst, firefox (optional), kitty, (optional), libreoffice (optional), lxsession, mailspring, mvp, neofetch, nitrogen (optional), nsxiv, nvim, ngvim, pavucontrol, pcmanfm, picom, pulseaudio, abittorrent, qt5ct, qtile, qtile extras, rofi, starship, sycthing (optional), zathura.

Copy the content of `.config` to your own `~/.config` folder, then copy `.bash_profile` to your home (`~`) folder.

Add this to your `/etc/bash.bashrc` (You will need sudo privilleges):

```
source `"$HOME/.config/bash/bashrc"
```
Reboot
