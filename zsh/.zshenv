# defaults
export EDITOR=nvim
export GPG_TTY=$(tty)
export MANPAGER="nvim +Man!"
export OPENER=handlr
export TERMINAL=kitty

# XDG
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# XDG Base Directories (https://wiki.archlinux.org/title/XDG_Base_Directory)
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod

# path updates
export PATH=$PATH:$GOPATH/bin
