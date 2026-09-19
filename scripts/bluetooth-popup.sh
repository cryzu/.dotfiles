#!/usr/bin/env bash

hyprctl dispatch killwindow title:wiremix
hyprctl dispatch killwindow class:nm-connection-editor
if hyprctl clients | grep -q 'class: blueberry.py'; then
    hyprctl dispatch killwindow class:blueberry.py
else
    hyprctl dispatch exec blueberry
fi