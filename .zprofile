if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi

[[ -f $ZDOTDIR/.zshrc ]] && . $ZDOTDIR/.zshrc 
. "$HOME/.cargo/env"
