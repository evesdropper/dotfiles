#!/bin/sh

# checks eligibility:
# all days: can't use after 22:00, before 9:00
# MWF: can't use from 13:00 to 17:00
# TR: can't use from 14:00 to 17:00
is_valid_time() {
    valid=true
    current_hour=$(date "+%H")
    current_day=$(date "+%u")
    if [[ $current_hour -ge 23 ]] || [[ $current_hour -le 9 ]]; then 
        valid=false
    elif [[ $current_day -le 5 ]] && [[ $(expr $current_day % 2) -eq 1 ]]; then
        if [[ $current_hour -ge 13 ]] && [[ $current_hour -le 16 ]]; then
            valid=false
        fi
    elif [[ $current_day -eq 2 ]] && [[ $current_day -eq 4 ]]; then
        if [[ $current_hour -ge 14 ]] && [[ $current_hour -le 16 ]]; then
            valid=false
        fi
    fi
    echo $valid
}

# changes exec to a close script and disables execution
set_exec_cmd() {
    if [[ $(is_valid_time) = true ]]; then
        sudo chmod u+x /usr/bin/discord-ptb
        exec_cmd=$(/usr/bin/discord-ptb)
    else
        sudo chmod u-x /usr/bin/discord-ptb 
        exec_cmd=$(zenity --info --text 'You are not allowed to use this application!')
    fi
    echo $exec_cmd
}

# closes any windows that might have gotten through, runs every 15 minutes
close_discord_cron(){
    kill $(ps aux | grep -i opt/discord-ptb)
    exit 0
}

# argument parsing 
if [ $# -eq 0 ]; then
    set_exec_cmd
elif [[ $1 == "-c" ]] || [[ $1 == "--cronjob" ]]; then 
    close_discord_cron
elif [[ $1 == "-v" ]] || [[ $1 == "--validtime" ]]; then 
    is_valid_time
else
    echo 'troll'
    exit 1
fi
