#!/bin/sh

# if already running, then exit
pkill --euid "$USER" wshowkeys && exit

# else check mode
[ "$#" -eq 0 ] && wshowkeys -a bottom -m 150 -t 1.5
[ "$1" = "-g" ] || [ "$1" = "--gif" ] && wshowkeys -a left -m 50 -t 1.5
