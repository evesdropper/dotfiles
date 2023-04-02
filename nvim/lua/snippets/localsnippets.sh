#!/bin/sh

TEXBOOK_PREAMBLE_DIR="$HOME/Documents/etc/tex/snippets/"
SYMLINK="$HOME/dotfiles/nvim/lua/localsnippets"
declare -A ENTRY_DIRS=( ["TeXromancers"]=$TEXBOOK_PREAMBLE_DIR ["Blank"]="$HOME" )

create_rofi_menu() {
    rofi_in=""
    for entry in "${!ENTRY_DIRS[@]}"; do
        rofi_in+="$entry\n"; # room to add icons and flashy stuff if wanted
    done
    selected=$(printf "$rofi_in" | rofi -dmenu -i -p "Change Localsnippets Dir: " -theme-str '@import "power.rasi"')
    set_symlink_from_rofi "$selected"
}

set_symlink_from_rofi() {
    if [[ $1 == "Blank" ]]; then 
        unlink $SYMLINK && exit 0
    fi
    entry_dir="${ENTRY_DIRS[$1]}"
    if [[ -d $entry_dir ]]; then
        [[ -h $SYMLINK ]] && unlink $SYMLINK
        ln -s $entry_dir $SYMLINK
    else
        echo "Invalid directory name specified, no action done."
        exit 25
    fi
}

create_rofi_menu
