#!/usr/bin/env bash
source "$(dirname "$(readlink -f "$0")")/popup-lib.sh"

close_window "title:wiremix"
close_window "class:blueberry.py"
if window_exists class nm-connection-editor; then
    close_window "class:nm-connection-editor"
else
    popup_exec "nm-connection-editor"
fi
