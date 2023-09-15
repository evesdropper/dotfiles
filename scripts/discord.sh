#!/bin/sh

# valid times: staff meeting M 3-4, OH T 12-2, Disc WF 5-6, dinner 7-8; class MWF 1-2/F 2-3
is_valid_mon=(13 15)
is_valid_tues=(12 13)
is_valid_weds=(13 17)
is_valid_fri=(13 14 17)
declare -A is_valid_days
is_valid_days[1]=${is_valid_mon[@]}
is_valid_days[2]=${is_valid_tues[@]}
is_valid_days[3]=${is_valid_weds[@]}
is_valid_days[5]=${is_valid_fri[@]}

# checks eligibility
is_valid_time() {
    valid=true
    current_hour=$(date "+%H")
    current_day=$(date "+%u")
    # if is_valid_days contains valid hours for the day 
    current_day_arr=${is_valid_days[$current_day]}
    [[ " ${current_day_arr[*]} " =~ " ${current_hour} " ]] && valid=true || valid=false
    if [[ $current_hour -eq 19 ]]; then 
        valid=true
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
