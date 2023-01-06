# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/dotfiles/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#!/bin/sh
# pathfinding 
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
export PATH=$PATH:/home/revise/texlive/2022/bin/x86_64-linux
export PATH=$PATH:/home/revise/.local/share/gem/ruby/3.0.0/bin
export PATH=$PATH:/home/revise/go/bin
 
# plugin manager
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

#
#plugins
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/vim"
plug "zap-zsh/fzf"
plug "zap-zsh/supercharge"
# plug "romkatv/powerlevel10k"
plug "zsh-users/zsh-syntax-highlighting"

# completion
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-.]=** r:|=**'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select=5
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/revise/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git | xargs nvim"

# history
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=10000
setopt autocd
bindkey -e

# LSD 
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# aliases 
# common places to go 
alias clearcd="clear; cd"
alias home='cd ~'
alias root='cd /'
alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'
alias docs='cd ~/Documents/'
alias notesdir='cd ~/Documents/university/bachelor-2/fa22/'
alias books='cd ~/Downloads/Documents/books/'
alias math='cd ~/Documents/university/etc/math/'
alias texbook="cd ~/Documents/etc/tex/"

# git commands
alias g='git'
alias gst='git status'
alias lg='git log'
alias gau='git add -u'
alias gaa='git add .'
alias gcm='git commit -m'
alias gsh='git stash'
alias gl="git log"
alias gp="git push"
alias gpl="git pull"

# tlmgr
alias tlm="sudo env PATH='$PATH' tlmgr"
alias s="kitty +kitten ssh"
alias icat="kitty +kitten icat"

# rc moment
alias bashrc="nvim ~/.bashrc"
alias zathurarc="nvim ~/.config/zathura/zathurarc"
alias vimdir="cd ~/.config/nvim/"
alias luasnip="cd ~/.config/nvim/luasnip/"
alias vimrc="nvim ~/.config/nvim/init.lua"
alias latexmkrc="nvim ~/.latexmkrc"
alias spellrc="nvim ~/.config/nvim/spell/en.utf-8.add"
alias preamble="nvim ~/texmf/tex/latex/styles/random.sty"
alias zshrc="nvim ~/dotfiles/.zshrc"
alias swhkdrc="nvim ~/dotfiles/swhkd/swhkdrc"

# keybinds 
bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' end-of-line  # shift + tab  | autosuggest

# up down 
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # ARROW_UP
bindkey "^[[B" down-line-or-beginning-search # ARROW_DOWN
#bindkey '^[[H' beginning-of-line
#bindkey '^[[F' end-of-line

export EDITOR="nvim"
export TERMINAL="kitty"
#export NVM_INC="/home/revise/.nvm/versions/node/v19.3.0/include/node"
export XDG_CURRENT_DESKTOP=Unity

# git 
source /usr/share/zsh/scripts/git-prompt.zsh
ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_TAG="%{$fg_bold[white]%}"

# prompt colors/styling!
PROMPT='%B%F{magenta}[%n:%f%F{blue}%(4~|../|)%3~%f%b$(gitprompt)%B%F{magenta}]%f%b ' # without hostname
# PROMPT='%B%F{magenta}[%n@%m:%f%F{blue}%(4~|../|)%3~%f%b$(gitprompt)%B%F{magenta}]%f%b ' # with hostname
RPROMPT='%B%F{red}%(0?||Exit code: %?)%f%b'

# syntax highlight

# To customize prompt, run `p10k configure` or edit ~/dotfiles/.p10k.zsh.
# [[ ! -f ~/dotfiles/.p10k.zsh ]] || source ~/dotfiles/.p10k.zsh

month="$(date +%m)"
year="$(date +%y)"

if [ $month -le 5 ]; then
    sem="sp"
elif [ $month -ge 8 ]; then 
    sem="fa"
else 
    sem="su"
fi

export CURRENT_SEM="$sem$year"

