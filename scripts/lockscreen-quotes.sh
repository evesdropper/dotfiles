#!/bin/sh

# silly ahh script to display stupid or not so stupid quotes on my lockscreen
QUOTES_DIR="$HOME/dotfiles/assets/quotes/"

# grab a random quote and display it as follows:
# [quote]
# \n
# - [name] (right aligned)
quotefile=$(find $QUOTES_DIR -type f | shuf -n 1)
name=$(yq ".name" $quotefile)
quote=$(yq ".quote" $quotefile)
context=$(yq ".context" $quotefile)
[[ $context == "null" ]] && context="" || context=", $context"

printf "\"%s\"\n\n%80s" "$(echo $quote | fmt -w 80)" "- $name$context"
