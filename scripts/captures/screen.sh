#!/bin/bash
grim -g "$(slurp)" -t ppm - | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
