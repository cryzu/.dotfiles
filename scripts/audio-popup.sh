#!/usr/bin/env bash
source "$(dirname "$(readlink -f "$0")")/popup-lib.sh"

close_window "class:nm-connection-editor"
close_window "class:blueberry.py"
if window_exists title wiremix; then
    close_window "title:wiremix"
else
    popup_exec "ghostty --title=wiremix --confirm-close-surface=false -e wiremix"
fi
