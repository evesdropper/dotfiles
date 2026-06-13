-- personal binds
local mainMod = "SUPER"
local mediaMod = "CTRL + ALT + SHIFT"

-- group
hl.bind(mainMod .. "+ T", hl.dsp.group.toggle())
hl.bind(mainMod .. "+ H", hl.dsp.group.prev())
hl.bind(mainMod .. "+ L", hl.dsp.group.next())
hl.bind(mainMod .. "+ SHIFT + L", hl.dsp.group.move_window())

-- rofi window mode
hl.bind(mainMod .. "+ W", hl.dsp.exec_cmd("rofi -show window"))

-- clipboard
hl.bind(mainMod .. "+ V", hl.dsp.exec_cmd("kitty --class clipse -e 'clipse'"))

-- media
hl.bind("Print", hl.dsp.exec_cmd("/home/revise/dotfiles/scripts/captures/screen.sh"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprpicker"))
hl.bind(mediaMod .. "+ R", hl.dsp.exec_cmd("/home/revise/dotfiles/scripts/captures/record.sh"))
hl.bind(mediaMod .. "+ G", hl.dsp.exec_cmd("/home/revise/dotfiles/scripts/captures/gifrecord.sh"))
hl.bind(mediaMod .. "+ K", hl.dsp.exec_cmd("/home/revise/dotfiles/scripts/captures/keys.sh"))
