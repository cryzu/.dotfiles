-- Programs and script paths shared by keybinds and autostart.
-- Everything is launched through uwsm so apps get their own systemd scope.

local M = {}

local scripts = "~/.config/scripts/"

--- Wrap a command so it runs as a uwsm-managed app.
function M.uwsm(cmd)
    return "uwsm app -- " .. cmd
end

M.terminal     = M.uwsm("ghostty")
M.fileManager  = M.uwsm("dolphin")
M.appMenu      = M.uwsm("rofi -show drun -run-command 'uwsm app -- {cmd}'")
M.browser      = M.uwsm("firefox")
M.discord      = M.uwsm("equibop")
M.codeEditor   = M.uwsm("code")
M.notes        = M.uwsm("obsidian")
M.steam        = M.uwsm("steam")
M.top          = M.uwsm("ghostty -e btop")
M.musicPlayer  = M.uwsm("spotify")

M.lockscreen   = M.uwsm("hyprlock")
M.screenshot   = M.uwsm("hyprshot -m region")
M.colorPicker  = M.uwsm("hyprpicker -a")

M.discordMute   = M.uwsm("equibop --toggle-mic")
M.discordDeafen = M.uwsm("equibop --toggle-deafen")

M.volumeUp        = M.uwsm(scripts .. "vol-up")
M.volumeDown      = M.uwsm(scripts .. "vol-down")
M.toggleVolume    = M.uwsm(scripts .. "vol-mute")
M.toggleMic       = M.uwsm(scripts .. "mic-mute")
M.brightnessUp    = M.uwsm(scripts .. "brightness-up")
M.brightnessDown  = M.uwsm(scripts .. "brightness-down")
M.toggleDisplay   = M.uwsm(scripts .. "toggle-display")
M.switchTheme     = M.uwsm(scripts .. "rofi-theme-selector.sh")

return M
