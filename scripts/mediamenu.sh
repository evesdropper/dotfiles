#!/bin/sh 

chosen=$(printf "  Capture Screen\n󰆞  Capture Region\n󱫟  Screen (5s delay)\n󰚖  Region (5s delay)\n  Start/Stop Video Recording\n󰵸  Start/Stop GIF Recording" | rofi -dmenu -i -p "Capture Options: " -theme-str '@import "media.rasi"')

case "$chosen" in
    "  Capture Screen") ~/dotfiles/scripts/screen.sh --screen ;;
	"󰆞  Capture Region") ~/dotfiles/scripts/screen.sh ;;
    "󱫟  Screen (5s delay)") ~/dotfiles/scripts/screen.sh --screen -d 5;;  
    "󰚖  Region (5s delay)") ~/dotfiles/scripts/screen.sh -d 5;; 
	"  Start/Stop Video Recording") ~/dotfiles/scripts/record.sh ;; 
	"󰵸  Start/Stop GIF Recording") ~/dotfiles/scripts/gifrecord.sh ;;
	*) exit 1 ;;
esac
