# ── Shell Options ────────────────────────────────────────────────
setopt autocd
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt globdots  # Include hidden files in glob/completion matches by default.

# ── History ──────────────────────────────────────────────────────
HISTSIZE=500
SAVEHIST=1000
bindkey '^R' history-incremental-search-backward

# ── Keybindings ──────────────────────────────────────────────────
bindkey -v  # vim keys
bindkey -v '^?' backward-delete-char

# ── Completion ───────────────────────────────────────────────────
autoload -Uz compinit
zmodload zsh/complist
_comp_options+=(globdots)        # Include hidden files.
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# SSH host completion: only use aliases from ~/.ssh/config, not known_hosts
_ssh_config_hosts() {
  local -a hosts
  hosts=(${(f)"$(awk '/^Host[[:space:]]/ { for (i=2; i<=NF; i++) if ($i !~ /[*?]/) print $i }' ~/.ssh/config 2>/dev/null)"})
  _describe 'host' hosts
}
compdef _ssh_config_hosts ssh scp sftp

# ── Aliases ──────────────────────────────────────────────────────
alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias cowsay='cowsay -f /usr/share/cowsay/cows/tux.cow'
alias grep='grep --color=auto'
# alias hc='ls ~ -lA | wc -l'
alias ls='eza --color=auto --icons=always -la'
alias pdpdf='pandoc --citeproc --pdf-engine=lualatex \
  --include-in-header="$HOME/.config/pandoc/header.tex" \
  --toc --csl="$HOME/.config/pandoc/apa.csl"'
alias shutnow='shutdown now'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"'
alias vim='nvim'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias svn="svn --config-dir \"$XDG_CONFIG_HOME\"/subversion"

# ── Virtualenv PATH Fix ──────────────────────────────────────────
if [[ -n $VIRTUAL_ENV && ":$PATH:" != *":$VIRTUAL_ENV/bin:"* ]]; then
  PATH="$VIRTUAL_ENV/bin:$PATH"
fi

# ── Auto-activate venv on cd ─────────────────────────────────────
chpwd_venv() {
  local -a candidates
  local venv_dir preferred

  # Prefer the common names, but fall back to scanning any dir with pyvenv.cfg.
  for preferred in .venv venv env .env; do
    [[ -f "$preferred/bin/activate" ]] && candidates+=("$preferred")
  done
  candidates+=(*/pyvenv.cfg(N:h))

  for venv_dir in $candidates; do
    if [[ -f "$venv_dir/bin/activate" ]]; then
      [[ -n $VIRTUAL_ENV ]] && deactivate 2>/dev/null
      source "$venv_dir/bin/activate"
      ls
      return
    fi
  done

  [[ -n $VIRTUAL_ENV ]] && deactivate 2>/dev/null
  ls
}
chpwd_functions+=(chpwd_venv)

# ── Plugins ──────────────────────────────────────────────────────
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── Tool Initialisers (last to reduce prompt flicker) ───────────
eval "$(starship init zsh)"
eval "$(antidot init)"
eval "$(zoxide init zsh)"
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# ── Greeting ─────────────────────────────────────────────────────
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
  printf '\n'
fi

if command -v fortune >/dev/null 2>&1; then
  fortune
  printf '\n'
fi


if command -v eza >/dev/null 2>&1; then
  eza --color=auto --icons=always -la
  printf '\n'
fi
