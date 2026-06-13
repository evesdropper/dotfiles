#!/usr/bin/env bash

# Adapted from https://github.com/end-4/dots-hyprland/blob/main/dots/.config/hypr/hyprlock/status.sh

############ Variables ############
enable_battery=false
battery_charging=false

declare -A battery_icons

battery_icons[0]="󰂎"
battery_icons[1]="󰁺"
battery_icons[2]="󰁻"
battery_icons[3]="󰁼"
battery_icons[4]="󰁽"
battery_icons[5]="󰁾"
battery_icons[6]="󰁿"
battery_icons[7]="󰂀"
battery_icons[8]="󰂁"
battery_icons[9]="󰂂"
battery_icons[10]="󰁹"

####### Check availability ########
for battery in /sys/class/power_supply/*BAT*; do
  if [[ -f "$battery/uevent" ]]; then
    enable_battery=true
    if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
      battery_charging=true
    fi
    break
  fi
done

############# Output #############
if [[ $enable_battery == true ]]; then
  if [[ $battery_charging == true ]]; then
    echo -n "󰂄 "
  else
    current_battery_level=$(cat /sys/class/power_supply/*/capacity | head -1)
    echo -n "${battery_icons[$(((current_battery_level + 5) / 10))]} "
  fi
  echo -n "$(cat /sys/class/power_supply/*/capacity | head -1)"%
  if [[ $battery_charging == false ]]; then
    echo -n " remaining"
  fi
fi

echo ''
