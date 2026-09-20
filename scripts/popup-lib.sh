# Shared helpers for the waybar popup scripts (source this file).

# Close every window matching a Hyprland window selector, e.g. "class:blueberry.py".
close_window() {
    hyprctl dispatch "hl.dsp.window.close({ window = '$1' })" >/dev/null
}

# Succeeds if a window has the given field (class/title) value.
window_exists() {
    hyprctl clients -j | jq -e --arg f "$1" --arg v "$2" 'any(.[]; .[$f] == $v)' >/dev/null
}

# Launch a command as a floating popup under the waybar module.
popup_exec() {
    hyprctl dispatch "hl.dsp.exec_cmd('$1', { float = true, size = '600 400', move = '1310 42' })" >/dev/null
}
