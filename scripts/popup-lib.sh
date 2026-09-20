# Shared helpers for the waybar popup scripts (source this file).

# Close every window matching a Hyprland window selector, e.g. "class:blueberry.py".
close_window() {
    hyprctl dispatch "hl.dsp.window.close({ window = '$1' })" >/dev/null
}

# Succeeds if a window has the given field (class/title) value.
window_exists() {
    hyprctl clients -j | jq -e --arg f "$1" --arg v "$2" 'any(.[]; .[$f] == $v)' >/dev/null
}

# Launch a command as a popup; float/position/animation come from the window
# rules in hypr/modules/rules.lua.
popup_exec() {
    hyprctl dispatch "hl.dsp.exec_cmd('$1')" >/dev/null
}
