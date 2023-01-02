#!/bin/bash

# couple lines of code to take screenshots and save with a file name.
screenshot_dir="$HOME/Pictures/Screenshots/"
# fname= $(zenity --entry --title="Take a Screenshot" --text="Image Name:") || $(date +%Y_%m%d_%H%M%S)
fileout="$screenshot_dir/$(zenity --entry --title="Take a Screenshot" --text="Image Name:").png"
[ -d "$screenshot_dir" ]; grim -g "$(slurp)" $fileout
swappy -f $fileout
wl-copy < $fileout
