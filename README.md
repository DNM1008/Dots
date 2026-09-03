# Dots

Personal configuration files for an Arch Linux + Qtile/KDE Plasma desktop.
`~/.config` and `~/.local` are symlinked straight to this repo — there's no
copy step, no symlink manager, edits under `~/.config` or `~/.local` *are*
edits to this repo.

Theme: **Catppuccin Macchiato** throughout.

---

## How it works

```
~/.config  ->  ~/Projects/personal/dots/.config
~/.local   ->  ~/Projects/personal/dots/.local
```

Both directories hold far more than dotfiles-worthy content (caches, browser
profiles, credentials, machine-specific state), so `.gitignore` uses a
**whitelist**: everything under `.config/` and `.local/` is ignored by
default, and specific paths are un-ignored with `!` rules. Anything not
explicitly listed in `.gitignore` stays local and untracked, even though it
physically lives inside the repo directory.

When adding a new config to track, add a matching `!.config/foo` (or
`.local/...`) line to `.gitignore` — otherwise it silently stays untracked.

### Secrets

Never hardcode API keys or credentials into a tracked config file. Put them
in `.env` at the repo root (gitignored) and source it from shell config:

```sh
[ -f "$HOME/Projects/personal/dots/.env" ] && source "$HOME/Projects/personal/dots/.env"
```

`.config/git/` and `.config/plasma-nm` (WiFi credentials) are deliberately
untracked for the same reason.

---

## Key configs

### Shell

| Path | Purpose |
|------|---------|
| `.config/bash/bash_profile` | Login shell — sets all XDG paths, env vars, tool paths, and sources `.env` |
| `.config/bash/bashrc` | Interactive bash — aliases, prompt (Starship), zoxide, fastfetch |
| `.config/zsh/.zshenv` | Zsh equivalent — XDG paths, env vars, sources `.env` |
| `.config/zsh/.zshrc` | Zsh interactive config |

Full XDG base directory compliance (`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, etc.)
is set in `bash_profile` / `.zshenv`.

### Window manager

| Path | Purpose |
|------|---------|
| `.config/kwinrc`, `.config/kwinrulesrc` | KDE Plasma/KWin |
| `.config/krohnkite/` | Tiling extension for KWin |
| `.config/qtile/config.py` | Qtile config — keybinds, layouts, bar, widgets (alternative WM, not primary) |
| `.config/qtile/autostart.sh` | Qtile autostart — xrandr, wallpaper, dunst, copyq, syncthing, udiskie |
| `.config/qtile/colors.py` | Catppuccin Macchiato colour definitions used by the Qtile bar |

The Qtile `autostart.sh` contains hardcoded xrandr commands for a specific
dual-monitor layout. Edit these if your outputs differ — check with `xrandr --query`.

### Terminal

| Path | Purpose |
|------|---------|
| `.config/kitty/kitty.conf` | Primary terminal — full config with Catppuccin Macchiato theme |
| `.config/alacritty/alacritty.toml` | Alternative terminal config |
| `.config/ghostty/config` | Ghostty config with Catppuccin theme variants |
| `.config/foot/foot.ini` | Wayland terminal |

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
| `.config/gtk-2.0/`, `.config/gtk-3.0/` | GTK theme settings and custom CSS |
| `.config/gtk-4.0/` | Symlinks to Catppuccin Macchiato system theme |
| `.config/qt5ct/`, `.config/qt6ct/` | Qt theme — Catppuccin Macchiato colour scheme |
| `.local/share/color-schemes/` | KDE colour scheme files |

### Input / fonts

| Path | Purpose |
|------|---------|
| `.config/fcitx5/` | Input method framework |
| `.config/fontconfig/` | Font configuration |
| `.config/kxkbrc` | Keyboard layout |

### Other tools

| Path | Purpose |
|------|---------|
| `.config/starship.toml` | Shell prompt |
| `.config/fastfetch/` | System info on shell startup |
| `.config/lazygit/` | Git TUI |
| `.config/wofi/` | Wayland launcher |
| `.config/pandoc/`, `.local/share/pandoc/` | Pandoc templates and defaults |
| `.local/bin/` | Personal scripts (`kshot`, `gtkrc-janitor.sh`) |
| `.local/share/applications/` | Custom `.desktop` entries |

---

## Deployment

On a fresh system:

```sh
git clone <this repo> ~/Projects/personal/dots
mv ~/.config ~/.config_bak   # back up whatever's there first
mv ~/.local  ~/.local_bak
ln -s ~/Projects/personal/dots/.config ~/.config
ln -s ~/Projects/personal/dots/.local  ~/.local
```

After that, changes to `~/.config`/`~/.local` are changes to this repo —
just `git add`/`commit`/`push` from `~/Projects/personal/dots` as normal.

No package list is tracked here — reinstalling packages is handled separately
by the [install script](https://github.com/DNM1008/Install-Script).
