#!/bin/sh

# new screenshot script
# TODO: get script to work with course-specific directories
DEFAULT_SCREENSHOT_DIR="$HOME/Pictures/Screenshots/"

# argument parsing
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--screen)
            FULL_SCREEN=YES
            shift 
            ;;
        "-w"|--window) 
            WINDOW=YES
            shift
            ;;
        "-d"|--delay)
            DELAY="$2"
            shift
            shift
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
    esac
done

# get filename; filename conventions defined below
# blank: temp/deleted screenshot 
# [folder] [name]: save in [folder]
# @c (h)? [name]: save in current-course/(notes|hw)/figures/
# @z [query] [name]: zoxide finds the top match, then places in that folder
# [name] must be one word, mostly for sanity reasons - I dislike files with names like "some dumb file name.png"
filename="$(zenity --entry --title="Take a Screenshot" --text="Image Name:")" || exit

IFS=' '
read -ra filenamearr <<< "$filename"
screenshot_dir=$DEFAULT_SCREENSHOT_DIR
if [[ ${#filenamearr[@]} -gt 1 ]]; then
    case ${filenamearr[0]} in
        "@z")
            screenshot_dir="$(zoxide query "${filenamearr[1]}" | sed 's/\\/\\\\/g;s/"/\\"/g')/"
            ;;
        "@c")
            if [[ ${#filenamearr[@]} -eq 2 ]] then
                screenshot_dir="$HOME/Documents/university/bachelor-3/current-course/notes/figures/"
            else
                screenshot_dir="$HOME/Documents/university/bachelor-3/current-course/hw/figures/"
            fi
            ;;
        *)
            screenshot_dir="$DEFAULT_SCREENSHOT_DIR${filenamearr[0]}/"
            ;;
    esac
    fileout="$screenshot_dir${filenamearr[-1]}.png"
else
    fileout="$DEFAULT_SCREENSHOT_DIR${filenamearr[0]}.png"
fi

echo $fileout

# make screenshot directory
[ -d "$screenshot_dir" ] || mkdir $screenshot_dir

# get coordinates, which will be used to resize satty window
if [[ $FULL_SCREEN == "YES" ]]; then
    if [[ -n "$DELAY" ]]; then 
        sleep $DELAY
    fi
    grim - | satty --filename - --output-filename $fileout
    exit 0
elif [[ $WINDOW == "YES" ]]; then 
    coords=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)
else
    coords=$(slurp) || exit
fi

# delay handling
if [[ -n "$DELAY" ]]; then 
    sleep $DELAY
fi

mapfile -t coords_array < $(echo $coords | grep -Po "[x\s]\K([0-9]+)")
xsize=$([[ ${coords_array[0]} -ge 1600 ]] && ${coords_array[0]} || 1600)
ysize=$([[ ${coords_array[1]} -ge 900 ]] && ${coords_array[1]} || 900)


# # take screenshot and copy to clipboard
grim -g "$coords" - | satty --filename - --output-filename $fileout
swaymsg for_window [app_id="satty"] resize set $xsize $ysize
