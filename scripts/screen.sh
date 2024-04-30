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
# [class]-[(n|h)] [name]: figure in class notes/hw 
# [folder] [name]: save in [folder]
# [name] must be one word, mostly for sanity reasons
filename="$(zenity --entry --title="Take a Screenshot" --text="Image Name:")" || exit

IFS=' '
read -ra filenamearr <<< "$filename"
screenshot_dir=$DEFAULT_SCREENSHOT_DIR
if [[ ${#filenamearr[@]} -gt 1 ]]; then
    screenshot_dir="$DEFAULT_SCREENSHOT_DIR${filenamearr[0]}/"
    filename=${filenamearr[1]}
    echo $screenshot_dir $filename
fi

fileout="$screenshot_dir$filename.png"
echo $fileout

# make screenshot directory
[ -d "$screenshot_dir" ] || mkdir $screenshot_dir

# get coordinates, which will be used to resize satty window
if [[ $FULL_SCREEN == "YES" ]]; then
    grim - | satty --filename - --output-filename $fileout
else
    coords=$(slurp) || exit
    mapfile -t coords_array < $(echo $coords | grep -Po "[x\s]\K([0-9]+)")
    xsize=$([[ ${coords_array[0]} -ge 1600 ]] && ${coords_array[0]} || 1600)
    ysize=$([[ ${coords_array[1]} -ge 900 ]] && ${coords_array[1]} || 900)
fi

if [[ -n "$DELAY" ]]; then 
    sleep $DELAY
fi

# # take screenshot and copy to clipboard
grim -g "$coords" - | satty --filename - --output-filename $fileout
swaymsg for_window [app_id="satty"] resize set $xsize $ysize
