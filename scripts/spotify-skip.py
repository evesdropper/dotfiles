#!/usr/bin/env python3

import gi
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib
from subprocess import Popen

player = Playerctl.Player()

played_out = ["If I Can't Have You", 'Walk And Talk', 'Neuland']

def on_track_change(player, e):
    if player.get_title() in played_out:
        player.next()

player.on('metadata', on_track_change)

GLib.MainLoop().run()
