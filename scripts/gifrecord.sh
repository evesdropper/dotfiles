#!/usr/bin/sh

# If an instance of wf-recorder is running under this user kill it with SIGINT and exit
pkill --euid "$USER" --signal SIGINT wf-recorder && exit

# Define paths
DefaultSaveDir=$HOME'/Videos/gifs/'
TmpPathPrefix='/tmp/gif-record'
TmpRecordPath=$TmpPathPrefix'-cap.mp4'
TmpPalettePath=$TmpPathPrefix'-palette.png'

# Trap for cleanup on exit
OnExit() {
	[[ -f $TmpRecordPath ]] && rm -f "$TmpRecordPath"
	[[ -f $TmpPalettePath ]] && rm -f "$TmpPalettePath"
}
trap OnExit EXIT

# Set umask so tmp files are only acessible to the user
umask 177

# Get selection and honor escape key
Coords=$(slurp) || exit

# Capture video using slurp for screen area
# timeout and exit after 10 minutes as user has almost certainly forgotten it's running
timeout 600 wf-recorder -g "$Coords" -f "$TmpRecordPath" || exit

# Get the filename from the user and honor cancel
SavePath=$( zenity \
	--file-selection \
	--save \
	--confirm-overwrite \
	--file-filter=*.gif \
	--filename="$DefaultSaveDir"'/.gif' \
) || exit

# Append .gif to the SavePath if it's missing
[[ $SavePath =~ \.gif$ ]] || SavePath+='.gif'

# Produce a pallete from the video file
ffmpeg -i "$TmpRecordPath" -filter_complex "palettegen=stats_mode=full" "$TmpPalettePath" -y || exit

# Return umask to default
umask 022

# Use pallete to produce a gif from the video file
ffmpeg -i "$TmpRecordPath" -i "$TmpPalettePath" -filter_complex "paletteuse=dither=sierra2_4a" "$SavePath" -y || exit
