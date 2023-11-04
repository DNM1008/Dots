# All of my Qtile configurations

Can be installed by the installed script in my repo (incoming)

Install yay first

To install: install all of the necessary software: alacritty, better discord,
copyq, dunst, emote (optional), eza, flameshot, firefox (optional), kitty,
(optional), libreoffice (optional), lxsession, ly (optional), mailspring, mvp,
neofetch, nitrogen (optional), nsxiv, nvim, ngvim, pavucontrol, pcmanfm, picom,
pulseaudio, qbittorrent, qt5ct, qtile, qtile extras, rofi, starship, sycthing
(optional), udiskie (optional but really recommended), xwallpaper, zathura.

For other programs that I might have forgotten, consult the `packages.txt` file 

Copy the content of `.config` to your own `~/.config` folder, then copy
`.bash_profile` to your home (`~`) folder.

I included a default wallpaper that you can put in `~/.cache`, though you can
get yourself a wallpaper :) and put it in `~/.cache`, name it `wall`
(xwallpaper will look for `wall` in `.cache`. Alternatively you can just use
nitrogen.

Add this to your `/etc/bash.bashrc` (You will need sudo privilleges):

``` source `"$HOME/.config/bash/bash_profile" ``` 

Reboot


# Keybinding

* Super + Caps Lock toggles the bar
* Super + D launches Discord
* Super + E launches PCManFM
* Super + Enter launches Alacritty
* Super + F toggles fullscreen
* Super + M launches Mailspring
* Super + P launches Rofi
* Super + Q closes the focused window
* Super + R launches a run prompt, but I only use it when other keybinds don't
  work
* Super + T toggles floating
  * Super + LMB moves the window
  * Super + RMB resizes the window
* Super + V toggles CopyQ main window
* Super + W launches Firefox if installed
* Super + Shift + S set up screenshot region, I set the default to just copy
  the screenshot to the clipboard instead of to a file
* Super + Shift + P launches Rofi Power Menu (if installed, not recommended
  though cuz normal rofi is quicker to just shutdown/reboot and I have not
  configured signout, and with an SSD you should be just as quick rebooting
  anyway)
* Super + Minus shrinks the window horizontally
* Super + Equal expands the window horizontally
* Super + H/J/K/L moves the focus onto window of relative positions
* Super + Shift + H/J/K/L moves the focused window in the stack or between the
  columns
* Super + Shift + R reloads Qtile configs (do this to apply changes that you
  made in the config file instead of rebooting/logging out)
* Super + Tab cycles between layouts
* There are other keybindings for layouts that I don't use (yet) but decided to
  leave them as is if you can make use of them

**Note**: To use the weather widget to its fullest, look to create your own api
key and add it in the config file, which already has a line for you to do it:
`# app_key="placeholder",`, simply replace the "placeholder" text with your own
key and uncomment the line (of course reload Qtile).

For funsies, you can either click on the Arch glyph on the top left (the first
widget on the bar) or hit Super + Backspace and you should have a dunst
notification that quotes a quote from fortune

If you just want the Qtile config, have a look at my [Qtile
config](https://github.com/DNM1008/Qtile-config)

## Credits [DistroTube](https://gitlab.com/dwt1)
