#!/usr/bin/env bash
# Usage: run-wallpaperengine.sh <wallpaper-engine-workshop-id>
cd /opt/linux-wallpaperengine
exec ./linux-wallpaperengine --disable-mouse --fps 60 --screen-root HDMI-A-1 --bg "$1" --screen-root eDP-1 --bg "$1"
