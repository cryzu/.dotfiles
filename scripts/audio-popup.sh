#!/usr/bin/env bash

hyprctl dispatch killwindow class:nm-connection-editor
hyprctl dispatch killwindow class:blueberry.py
if hyprctl clients | grep -q 'title: wiremix'; then
    hyprctl dispatch killwindow title:wiremix
else
    hyprctl dispatch exec "[float;size 600 400;move 1310 42]" "ghostty --title=wiremix --confirm-close-surface=false -e wiremix"
fi