#!/bin/sh

# completion
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-.]=** r:|=**'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select=5
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/revise/.config/zsh/.zshrc'

autoload -Uz compinit
compinit -C -d "$XDG_CACHE_HOME/zsh/.zcompdump"

# plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# history
HISTFILE="$XDG_STATE_HOME/zsh/.histfile"
HISTSIZE=100000
SAVEHIST=10000
setopt autocd
bindkey -e

# fzf
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git | xargs nvim"

# kitty
alias icat="kitten icat"
alias s="kitten ssh"

# lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias tree='ls --tree'

# nvm
source /usr/share/nvm/init-nvm.sh

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# ssh (https://wiki.archlinux.org/title/SSH_keys#Keychain)
eval "$(keychain --absolute --dir $XDG_RUNTIME_DIR/keychain --eval --quiet --noask gh_nightfall)"
