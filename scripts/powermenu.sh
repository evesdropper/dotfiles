! /bin/sh
chosen=$(printf "  Power Off\n  Restart\n󰿅  Log Out\n⏾  Suspend\n  Lock" | rofi -dmenu -i -p "Power Options:" -theme-str '@import "power.rasi"')

case "$chosen" in
    "  Power Off") poweroff ;;
    "  Restart") reboot ;;
    "󰿅  Log Out") swaymsg exit ;;
    "⏾  Suspend") systemctl suspend ;; 
    "  Lock") gtklock -d ;;
    *) exit 1 ;;
esac
