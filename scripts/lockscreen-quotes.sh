#!/bin/sh
NVIM_QUOTE=0

while [ $# -gt 0 ]; do
    case $1 in
        "-n"|--nvim)
            NVIM_QUOTE=1
            shift
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
    esac
done

# silly ahh script to display stupid or not so stupid quotes on my lockscreen
QUOTES_DIR="$HOME/dotfiles/assets/quotes/"

# grab a random quote and display it as follows:
# [quote]
# \n
# - [name] (right aligned)
generate_quote() {
    quotefile=$(find "$QUOTES_DIR" -type f -name '*.yml' | shuf -n 1)
    name=$(yq -r ".name" "$quotefile") || name="canonical bunger"
    quote=$(yq -r ".quote" "$quotefile") || quote="Let it Happen"
    context=$(yq -r ".context" "$quotefile") || context="null"
    [ "$context" = "null" ] && context="" || context=", $context"

    if [ "$NVIM_QUOTE" -eq 1 ]; then
        printf "\"%s\"\n\n%60s" "$(echo "$quote" | fmt -w 60)" "- $name$context"
    else
        printf "\"%s\"\n\n%80s" "$(echo "$quote" | fmt -w 80)" "- $name$context"
    fi
}

generate_quote
