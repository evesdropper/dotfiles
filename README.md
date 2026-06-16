# p15v dotfiles
After graduating from school and being employed, I admittedly do not use my personal laptops much. It's been easy to avoid friction and keep using an old setup that sort of worked as long as I could do basic things like ensure packages are updated, open a browser, and listen to music. My old Sway setup on the P52 was getting stale and having things fall apart due to updates, so I finally started fixing things and tinkering with some new software. 

## Updates
Some larger changes:
- sway -> hyprland: needed a change, hypr ecosystem made e.g. idle + lock easier to configure, Lua
- waybar -> ashell: better out of the box configuration
- cliphist -> clipse: TUI over Rofi selector

Some slightly less large changes:
- Better organization of scripts, have a `cron/` for cron scripts and a `captures/` for media (GIF/video/image) captures
  * scripts to routinely download things I need
  * script to properly sync up music playlists so that they're playable on ncmpcpp/VLC/AIMP
- keychain to store SSH keys
- added an `.editorconfig`, this change is vetted by a principal engineer

Todos/Possible Changes:
- [ ] finish yazi setup
- [ ] minimal/server nvim setup
- [ ] looking into walker, seeing if it might be something that replaces rofi?
