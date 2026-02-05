
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# Use XDG dirs for completion and history files
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh

[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache


alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias cowsay='cowsay -f /usr/share/cowsay/cows/tux.cow'
alias grep='grep --color=auto'
alias hc='ls ~ -lA | wc -l'
alias ls='eza --color=auto --icons=always -la'
alias pdpdf='pandoc --citeproc --pdf-engine=lualatex --include-in-header="/home/zeus/.config/pandoc/header.tex" --toc --csl="/home/zeus/.config/pandoc/apa.csl"'
alias shutnow='shutdown now'
alias vim="nvim"
alias wget="wget --hsts-file="${XDG_CACHE_HOME}/wget-hsts""

# Better cd
cd() {
  builtin cd "$@" && eza --color=auto --icons=always -la
}

eval "$(starship init zsh)"	# Starship prompt

# Pretty (?) neofetch and a quote to start
fastfetch && echo && fortune && echo

# Fix broken venv activation if needed
if [ -n "$VIRTUAL_ENV" ] && [[ ":$PATH:" != *":$VIRTUAL_ENV/bin:"* ]]; then
    export PATH="$VIRTUAL_ENV/bin:$PATH"
fi

# Plugins
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# # At the bottom of ~/.zshrc
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source '/usr/share/zsh-antidote/antidote.zsh'
# zstyle ':antidote:bundle' use-friendly-names 'yes'
# antidote bundle zsh-users/zsh-autosuggestions
# antidote bundle zsh-users/zsh-syntax-highlighting

antidote load

# Fix visual conflict between zsh-autosuggestions and fzf-tab
zstyle ':completion:*' widget-style menu-select
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(forward-word)
