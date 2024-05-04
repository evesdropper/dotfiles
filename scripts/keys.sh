#!/bin/sh
export WSHOWKEYS_MODE="video"

pkill --euid "$USER" wshowkeys && exit


if [ $# -eq 0 ]; then
    ~/Documents/code/wshowkeys/build/wshowkeys -a bottom -m 150 -t 1.5
elif [ $1 == "-g" -o $1 == "--gif" ]; then 
    ~/Documents/code/wshowkeys/build/wshowkeys -a left -m 50 -t 1.5
fi

