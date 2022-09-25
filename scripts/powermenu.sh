#! /bin/sh

chosen=$(printf "  Power Off\n  Restart\n  Logout \n  Lock" | rofi -dmenu -i -theme-str '@import "power.rasi"')

case "$chosen" in
	"  Power Off") poweroff ;;
	"  Restart") reboot ;;
	"  Logout") swaymsg exit ;;
	"  Lock") swaylock --font monospace --effect-blur 7x5 --effect-vignette -0.5:0.5 --grace 2 --fade-in 0.2 ;;
	*) exit 1 ;;
esac
