#!/bin/sh
FACE_DIR="$HOME/dotfiles/assets/bedge"

userimg=$(find "$FACE_DIR" -type f -name '*.png' | shuf -n 1)
[ -e /home/revise/.face ] && unlink /home/revise/.face
ln -s "$userimg" /home/revise/.face
