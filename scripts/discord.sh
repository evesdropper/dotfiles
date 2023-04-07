#!/bin/sh

# changes exec to a close script
set_exec_cmd() {
    if [[ $(date "+%H") -eq  21 ]]; then
        exec_cmd=$(/usr/bin/discord)
    else 
        exec_cmd=$(zenity --info --text 'You are not allowed to use this application!')
    fi
    echo $exec_cmd
}

# closes any windows that might have gotten through, runs every hour
close_discord() {
    kill $(ps aux | grep -i opt/discord)
}

# argument parsing 
if [ $# -eq 0 ]; then
    set_exec_cmd
elif [[ $1 == "-c" ]] || [[ $1 == "--cronjob" ]]; then 
    close_discord
else
    echo 'troll'
    exit 1
fi
