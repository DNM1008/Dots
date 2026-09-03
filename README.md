# Dots

Personal configuration files for an Arch Linux + KDE desktop. Deployed
automatically by the [install script](https://github.com/DNM1008/Install-Script)
via `cp -r .config/* ~/.config/` and `cp -r .local/* ~/.local/`.

Theme: **Catppuccin Macchiato** throughout.

---

## Structure

```
.config/        All XDG config files (copied to ~/.config/)
.local/         Several local scripts (copied to ~/.local/)
```

---

## Key configs

### Shell

| Path | Purpose |
|------|---------|
| `.config/bash/bash_profile` | Login shell — sets all XDG paths, env vars, and tool paths. Sourced system-wide via `/etc/bash.bashrc` by the install script. |
| `.config/bash/bashrc` | Interactive bash — aliases, prompt (Starship), zoxide, fastfetch |
| `.config/zsh/.zshrc` | Zsh equivalent; uses Antidote for plugin management |

Key environment variables set in `bash_profile` and `.zshenv`:
- `TERMINAL=kitty`
- `EDITOR=nvim`
- `BROWSER=firefox`
- `TERM=xterm-kitty`
- Full XDG base directory compliance (`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, etc.)

### Window manager: Qtile (WIP)

| Path | Purpose |
|------|---------|
| `.config/qtile/config.py` | Main Qtile config — keybinds, layouts, bar, widgets |
| `.config/qtile/autostart.sh` | Autostart — xrandr, wallpaper, dunst, copyq, syncthing, udiskie |
| `.config/qtile/colors.py` | Catppuccin Macchiato colour definitions used by the bar |
| `.config/awesome/rc.lua` | Awesome WM config (alternative WM, not the primary) |

The `autostart.sh` contains hardcoded xrandr commands for a specific
dual-monitor layout. Edit these if your outputs differ — check with `xrandr --query`.

### Terminal

| Path | Purpose |
|------|---------|
| `.config/kitty/kitty.conf` | Primary terminal — full config with Catppuccin Macchiato theme |
| `.config/alacritty/alacritty.toml` | Alternative terminal config |
| `.config/ghostty/config` | Ghostty config with Catppuccin theme variants |

See [NOTES.md in the install script repo](https://github.com/DNM1008/Install-Script/blob/main/NOTES.md)
for how to make Thunar and KDE open files in Kitty rather than Konsole.

### File manager

| Path | Purpose |
|------|---------|
| `.config/Thunar/uca.xml` | Custom actions — "Open Terminal Here" opens Kitty |

### Editor

| Path | Purpose |
|------|---------|
| `.config/nvim/` | Neovim config using lazy.nvim; `init.lua` is the entry point |

### Theming

| Path | Purpose |
|------|---------|
| `.config/gtk-3.0/` | GTK3 theme settings and custom CSS |
| `.config/gtk-4.0/` | Symlinks to Catppuccin Macchiato system theme |
| `.config/qt5ct/` | Qt5 theme — Catppuccin Macchiato colour scheme |
| `.config/qt6ct/` | Qt6 equivalent |
| `.config/Kvantum/` | Kvantum Qt theme engine config |

### Launchers and notifications

| Path | Purpose |
|------|---------|
| `.config/rofi/` | Application launcher config (for X11 use - WIP) |
| `.config/dunst/` | Notification daemon (if you're using a tiling wm - WIP)|
| `.config/wofi/` | Wayland launcher (for Wayland use) |

### Other tools

| Path | Purpose |
|------|---------|
| `.config/starship.toml` | Shell prompt |
| `.config/fastfetch/` | System info on shell startup |
| `.config/yazi/` | TUI file manager |
| `.config/ranger/` | Alternative TUI file manager |
| `.config/mpv/` | Video player |
| `.config/zathura/` | PDF viewer |
| `.config/lazygit/` | Git TUI |

---

## Deployment

Deployed by the install script on a fresh Arch install. To update an existing
system after changing configs here:

```sh
cd ~/path/to/Dots
cp -r .config/* ~/.config/
cp -r .local/* ~/.local/
```

*Make sure to point your shell config to the right place, for example I have
`/etc/bash.bashrc` sources `~/.config/bash/bash_profile` and set `$ZDOTDIR` to
`~/.config/zsh` in `/etc/zsh/zshenv`*

You can either use symlinks or copy the config files straight over

No package list is tracked here — reinstalling packages is handled separately
by the [install script](https://github.com/DNM1008/Install-Script).
