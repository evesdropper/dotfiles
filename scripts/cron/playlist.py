#!/bin/python
import argparse
import os

# vars
HOME = os.path.expanduser("~")
MUSIC_FOLDER = f"{HOME}/Music"
PLAYLIST_FOLDER = f"{HOME}/.config/mpd/playlists"
PLAYLIST_EXTENSIONS = (".m3u", ".m3u8")

# iterate through all files, check if is .m3u/.m3u8, symlink to playlists folder
def symlink_playlists(fname, reverse, debug):
    # reverse mode: move to Music folder only if it's an actual file
    if reverse:
        src_filepath = os.path.join(PLAYLIST_FOLDER, fname)
        print(src_filepath, os.path.islink(src_filepath))
        if os.path.islink(src_filepath):
            print("don't run on a symlink")
            return
        else:
            print(f"moving {src_filepath} to {MUSIC_FOLDER}")
            dst_filepath = os.path.join(MUSIC_FOLDER, fname)
            os.rename(src_filepath, dst_filepath)
    src_filepath = os.path.join(MUSIC_FOLDER, fname)
    dst_filepath = os.path.join(PLAYLIST_FOLDER, fname)
    if not os.path.isfile(dst_filepath):
        if debug:
            print(f"symlinking {src_filepath} to {dst_filepath}")
        os.symlink(src_filepath, dst_filepath)
    # clean up dead symlinks
    for filename in os.listdir(PLAYLIST_FOLDER):
        src_filepath = os.path.join(MUSIC_FOLDER, filename)
        dst_filepath = os.path.join(PLAYLIST_FOLDER, filename)
        if not os.path.isfile(src_filepath) and os.path.islink(dst_filepath):
            if debug:
                print(f"cleaning up dead link {dst_filepath}")
            os.remove(dst_filepath)

# argparse
parser = argparse.ArgumentParser()
parser.add_argument("fname", type=str, help="filename")
parser.add_argument("-r", "--reverse", help="reverse mode (move from mpd to Music, then symlink)", action="store_true")
parser.add_argument("--debug", help="increase output verbosity", action="store_true")
args = parser.parse_args()

if args.fname.lower().endswith(PLAYLIST_EXTENSIONS):
    if args.debug:
        print(f"running symlink_playlists({args.fname}, {args.reverse}, {args.debug})")
    symlink_playlists(args.fname, args.reverse, args.debug)
