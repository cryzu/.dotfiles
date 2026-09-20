#!/usr/bin/env bash
source "$(dirname "$(readlink -f "$0")")/popup-lib.sh"

close_window "title:wiremix"
close_window "class:nm-connection-editor"
if window_exists class blueberry.py; then
    close_window "class:blueberry.py"
else
    popup_exec "blueberry"
fi
