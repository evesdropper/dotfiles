#!/bin/sh 

screenshot_dir="$HOME/Documents/university/bachelor-2/fa22/cs61c/notes"
figures_dir="$screenshot_dir/figures"
fileout="$figures_dir/$(zenity --entry --title="Take a Lecture Screenshot" --text="Figure Name:").png"
[ -d "$figures_dir" ] || mkdir $figures_dir
[ -d "$figures_dir" ]; grim -g "$(slurp)" $fileout
