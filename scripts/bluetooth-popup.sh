#!/usr/bin/env bash
source "$(dirname "$(readlink -f "$0")")/popup-lib.sh"

close_window "title:wiremix"
close_window "class:nm-connection-editor"
if window_exists class blueberry.py; then
    close_window "class:blueberry.py"
else
    # Floated and positioned by the "bluetooth-popup" window rule
    hyprctl dispatch "hl.dsp.exec_cmd('blueberry')" >/dev/null
fi
