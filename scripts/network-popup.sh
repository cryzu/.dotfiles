#!/usr/bin/env bash

hyprctl dispatch killwindow title:wiremix
hyprctl dispatch killwindow class:blueberry.py
if hyprctl clients | grep -q 'class: nm-connection-editor'; then
    hyprctl dispatch killwindow class:nm-connection-editor
else
    hyprctl dispatch exec "[float;size 600 400;move 1310 42]" "nm-connection-editor"
fi