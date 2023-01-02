#!/bin/sh 

# couple lines of code to take screenrecords and save with a file name.
record_dir="$HOME/Videos/screencasts"
# fname= $(zenity --entry --title="Take a Screenshot" --text="Image Name:") || $(date +%Y_%m%d_%H%M%S)
fileout="$record_dir/$(zenity --entry --title="Take a Screen Recording" --text="Video Name:").mp4"
[ -d "$record_dir" ]; wf-recorder -g "$(slurp)" -f $fileout
