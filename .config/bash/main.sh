# ~/.config/bash/main.sh

# ── Prevent double sourcing ───────────────────────────
[[ -n $__BASH_MAIN_LOADED__ ]] && return
__BASH_MAIN_LOADED__=1

# ── Login shell-only settings ─────────────────────────
if shopt -q login_shell; then
  # Set DISPLAY only in X11
  [[ "$XDG_SESSION_TYPE" == "x11" ]] && export DISPLAY=:0

  export INIT_X11_SCALE_FACTOR=1.5
  export WINIT_HIDPI_FACTOR=1.0

  export XDG_CACHE_HOME="$HOME/.cache"
  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_DATA_HOME="$HOME/.local/share"
  export XDG_STATE_HOME="$HOME/.local/state"

  export LANG="en_GB.UTF-8"
  export LC_ALL="en_GB.UTF-8"

  export ANDROID_HOME="$XDG_DATA_HOME/android"
  export BROWSER="firefox"
  export CARGO_HOME="$XDG_DATA_HOME/cargo"
  export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
  export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
  export EDITOR="nvim"
  export GNUPGHOME="$XDG_DATA_HOME/gnupg"
  export GOPATH="$XDG_DATA_HOME/go"
  export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
  export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc:$XDG_CONFIG_HOME/gtk-2.0/gtkrc.mine"
  export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
  export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
  export HISTFILE="$XDG_STATE_HOME/bash/history"
  export LS_COLORS="tw=00;33:ow=01;33:"
  export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
  export NO_AT_BRIDGE=1
  export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
  export npm_config_cache="$XDG_CACHE_HOME/npm"
  export prefix="$XDG_DATA_HOME/npm"
  export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"
  export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
  export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
  export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
  export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
  export PYTHONUSERBASE="$XDG_DATA_HOME/python"
  export RANGER_LOAD_DEFAULT_RC=FALSE
  export TERM="xterm-kitty"
  export TERMINAL="kitty"
  export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
  export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
  export TEXMHOME="$XDG_DATA_HOME/texmf"
  export TESSDATA_PREFIX="/usr/share"
  export NLTK_DATA="/usr/share/nltk_data"
  export REDISCLI_HISTFILE="$XDG_DATA_HOME/redis/rediscli_history"
  export VALKEYCLI_HISTFILE="$XDG_DATA_HOME/valkey/valkeycli_history"
  export QT_QPA_PLATFORM="xcb"

  # PATH setup
  export PATH="/usr/bin:$PATH"
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.local/bin/miniconda3:$PATH"
  export PATH="$HOME/.local/bin/scripts:$PATH"
  export PATH="$HOME/.local/share/python/bin:$PATH"
  export PATH="/opt/nvim-linux64/bin:$PATH"
fi

# ── Interactive shell-only settings ───────────────────
[[ $- != *i* ]] && return

# Blesh (non-attached)
[[ -f /usr/share/blesh/ble.sh ]] && source /usr/share/blesh/ble.sh --noattach
[[ -f ~/.config/blesh/colors.macchiato ]] && source ~/.config/blesh/colors.macchiato

# Shell options
shopt -s autocd
bind 'set completion-ignore-case on'

# History settings
HISTSIZE=500
HISTFILESIZE=1000

# Aliases
alias adb='HOME="$XDG_DATA_HOME/android" adb'
alias cowsay='cowsay -f /usr/share/cowsay/cows/tux.cow'
alias grep='grep --color=auto'
alias hc='ls ~ -lA | wc -l'
alias ls='eza --color=auto --icons=always -la'
alias pdpdf='pandoc --citeproc --pdf-engine=lualatex \
  --include-in-header="$HOME/.config/pandoc/header.tex" \
  --toc --csl="$HOME/.config/pandoc/apa.csl"'
alias shutnow='shutdown now'
alias vim='nvim'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'

# Prompt
eval "$(starship init bash)"

# Optional banner
command -v fastfetch &>/dev/null && fastfetch && echo
command -v fortune &>/dev/null && fortune && echo

# Bash completion
[[ -r /usr/share/bash-completion/bash_completion ]] && \
  . /usr/share/bash-completion/bash_completion

# Fix for broken virtualenv path
[[ -n $VIRTUAL_ENV && ":$PATH:" != *":$VIRTUAL_ENV/bin:"* ]] && \
  export PATH="$VIRTUAL_ENV/bin:$PATH"

# Antidot
eval "$(antidot init)"

# Reattach Blesh if available
[[ ${BLE_VERSION-} ]] && ble-attach
