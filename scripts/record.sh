#!/usr/bin/sh

# If an instance of wf-recorder is running under this user kill it with SIGINT and exit
pkill --euid "$USER" --signal SIGINT wf-recorder && exit

# Define paths
DefaultSaveDir=$HOME'/Videos/screencasts/'
TmpPathPrefix='/tmp/record'
TmpRecordPath=$TmpPathPrefix'-cap.mp4'

# Trap for cleanup on exit
OnExit() {
	[[ -f $TmpRecordPath ]] && rm -f "$TmpRecordPath"
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
	--file-filter=*.mp4 \
	--filename="$DefaultSaveDir"'/.mp4' \
) || exit

# Append .gif to the SavePath if it's missing
[[ $SavePath =~ \.mp4$ ]] || SavePath+='.mp4'

mv "$TmpRecordPath" "$SavePath"

# Return umask to default
umask 022
