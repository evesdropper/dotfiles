#!/bin/sh

# new screenshot script
# TODO: get script to work with course-specific directories
DEFAULT_SCREENSHOT_DIR="$HOME/Pictures/Screenshots/"

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

# take screenshot and copy to clipboard
grim -g "$(slurp)" -
wl-copy < -

# edit screenshot 
satty --filename - --output-filename "$screenshot_dir$filename.png"
