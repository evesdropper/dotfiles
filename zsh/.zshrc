#!/bin/sh

# git prompt 
source /usr/share/zsh/scripts/git-prompt.zsh
ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_TAG="%{$fg_bold[white]%}"

# prompt colors/styling
PROMPT='%B%F{magenta}[%n:%f%F{blue}%(4~|../|)%3~%f%b$(gitprompt)%B%F{magenta}]%f%b ' # without hostname
# PROMPT='%B%F{magenta}[%n@%m:%f%F{blue}%(4~|../|)%3~%f%b$(gitprompt)%B%F{magenta}]%f%b ' # with hostname
RPROMPT='%B%F{red}%(0?||Exit code: %?)%f%b'

# history
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=10000
setopt autocd
bindkey -e

# exports
export EDITOR=nvim
export OPENER=handlr
export TERMINAL=kitty

# lsd 
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias tree='ls --tree'

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# ssh
eval "$(ssh-agent -s)" &>/dev/null
