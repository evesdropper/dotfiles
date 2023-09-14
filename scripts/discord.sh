#!/bin/sh

# checks eligibility:
# valid times: staff meeting M 3-4, OH T 12-2, Disc WF 5-6, dinner 7-8
is_valid_time() {
    valid=true
    current_hour=$(date "+%H")
    current_day=$(date "+%u")
    if [[ $current_hour -ne 19 ]]; then 
        valid=false
    elif [[ $current_day -eq 1 ]] && [[ $current_hour -ne 15 ]]; then
        valid=false
    elif [[ $current_day -eq 2 ]]; then
        if [[ $current_hour -le 12 ]] && [[ $current_hour -ge 13 ]]; then
            valid=false
        fi
    elif [[ $current_day -eq 3 ]] || [[ $current_day -eq 5 ]]; then
        if [[ $current_hour -ne 17 ]]; then 
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
    disc_processes=$(ps aux | grep -i opt/discord-ptb)
    if [[ $(is_valid_time) = false ]] && [[ -n $disc_processes ]]; then
        kill $disc_processes
    fi
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
