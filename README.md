# All of my Qtile configurations

Can be installed by the installed script in my repo (incoming)

Install `yay` first

Since you have yay, `base-devel` and `git` are installed. You will need to
install `psutil`, `pulsectl-asyncio` for the temperature, CPU, Memory, Volume
and Battery widgets to work.

You will need a terminal, I recommend Alacritty and have set it up to be the
default terminal. You can install Alacritty or use your own terminal by editing
the config file at `.config/qtile/config.py`, the variable that you need to
edit is `myTerm`.

As for browsers, I recommend Firefox, but again, you can choose whatever you
want, just edit the variable `myBrowser` in the config fire.

For a mail client, I use Mailspring, but you can edit the variable `myMail` to
whatever you like.

Flameshot is the allround screenshot utility for me. `maim` is a good
lightweight alternative but it is slightly harder to use since it doesn't pause
the screen for you and I have been having problems with taking the screenshot
of the whole screen, but I do change between the two. The relevant variable is
`screenshot`.

You will also have to install `eza`, since I have aliased `ls` to using it.

Other software that you'd want to install to get basic functions:
* dunst
* eof
* fira mono font (for alacritty)
* greenclip
* i3lock
* maim (or flameshot)
* mpv
* nerd fonts
* microsoft fonts
* nvim
* ngvim
* pavucontrol
* pcmanfm
* picom
* pulseaudio
* qt5ct
* qtile & qtile-extras (duh)
* rofi
* starship
* xclip
* xorg
* xrdb
* xss-lock
* xwallpaper (or feh or any other wallpaper setter)

Of course, you can use alternatives, but this is what I use and this config
file is designed to work around them, jst remember to edit the files
`config.py` and `autostart.sh` to your liking.

You should also install the [Catppuccin](https://github.com/catppuccin/Catppuccin) GTK and QT themes. The `gtkrc` file in `./config/gtk2.0/` can be copied to `/etc/gtk-2.0/` to apply the GTK theme.

I have fortune-mod and neofetch in my bashrc, they are not strictly needed as the terminal should still work without them, but I think you should install them.

Another application that is not strictly needed but I would strongly recommend is antidot, it cleans up your home directory. After installing, you should run `antidot update && antidot clean`.


*If you use another language like me*: install fcitx.

These are not necessary, but can be really convenient: zathura and its
extensions, I choose mupdf over poppler, but that's just me. If you use LaTex
or pandoc, you should install them to, I have an alias `pdpdf` which shortens
the command to render markdown files to pdf files, using the `lualatex` engine.
It adds a table of content as well as citations.

For other programs that I might have forgotten, consult the `packages.txt` file 

***DO NOT install Pipewire!*** At least at the time of writing this Qtile's
Volume Widget is still using commands and programs from good ol' Pulseaudio.
`amixer` refused to work with Pipewire and worked the moment I switched out
Pipewire for Pulseaudio.

Copy the content of `.config` to your own `~/.config` folder, then add `source /home/<your user name>/.config/bash/bash_profile` to `/etc/bash.bashrc`


The config files should already have a wallpaper and a lockscreen wallpaper
(the lockscreen wallpaper is set to 1388x768 because that's my current
resolution, you might want to resize it to your liking. I also included another
wallpaper for you. By defalt, xwallpaper will look for `wall` in
`~.config/qtile` for the wallpaper and `i3lock` will look for `lock` in the
same directory for the lock screen. To change the wallpaper/lockscreen, just
replace these files (make sure the name is correct). Alternatively, for the
wallpaper, you can use nitrogen :D. Add this to your `/etc/bash.bashrc` (You
will need sudo privilleges):

``` source `"$HOME/.config/bash/bash_profile" ``` 

Reboot


# Keybinding

* Super + 1 to 9 to switch to workspace
    * Super + Shift + 1 to 9 to move highlighted window to workspaces
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
configured signout, and with an SSD you should be just as quick rebootingj
anyway)
* Super + Minus shrinks the window horizontally
* Super + Equal expands the window horizontally
* Super + H/J/K/L moves the focus onto window of relative positions
* Super + Shift + H/J/K/L moves the focused window in the stack or between the
columns
* Super + Shift + R reloads Qtile configs (do this to apply changes that you
made in the config file instead of rebooting/logging out)
* Super + Shift + Q launches Oblogout
* Super + Tab cycles between layouts
* There are other keybindings for layouts that I don't use (yet) but decided to
leave them as is if you can make use of them


For funsies, you can either click on the Arch glyph on the top left (the first
widget on the bar) to have a reminder that you are using Arch (btw) or hit Super + Backspace and you should have a dunst
notification that quotes a quote from fortune.

If you just want the Qtile config, have a look at my [Qtile
config](https://github.com/DNM1008/Qtile-config)

You might want to check out my [Firefox config](https://github.com/DNM1008/Firefox-userChrome)

## Credits

[DistroTube](https://gitlab.com/dwt1)

