-- https://wiki.hypr.land/Configuring/Basics/Binds/

local p = require("modules.programs")

local mod = "SUPER"

--- Bind mod + key to a shell command.
local function exec(keys, cmd, opts)
    return hl.bind(keys, hl.dsp.exec_cmd(cmd), opts)
end

-- System
hl.bind(mod .. " + Q", hl.dsp.window.close())
exec(mod .. " + SHIFT + ESCAPE", "uwsm stop")
exec(mod .. " + ESCAPE", p.lockscreen)
exec(mod .. " + Z", p.discordMute)
exec(mod .. " + SHIFT + Z", p.discordDeafen)
exec(mod .. " + SHIFT + SPACE", p.switchTheme)
exec(mod .. " + SHIFT + S", p.screenshot)
exec(mod .. " + SHIFT + C", p.colorPicker)
exec(mod .. " + SPACE", p.appMenu)

-- Applications
exec(mod .. " + RETURN", p.terminal)
exec(mod .. " + F", p.fileManager)
exec(mod .. " + B", p.browser)
exec(mod .. " + D", p.discord)
exec(mod .. " + C", p.codeEditor)
exec(mod .. " + O", p.notes)
exec(mod .. " + S", p.steam)
exec(mod .. " + T", p.top)
exec(mod .. " + M", p.musicPlayer)

-- Volume / brightness (work while locked, repeat while held)
local media = { locked = true, repeating = true }
exec("XF86AudioRaiseVolume",  p.volumeUp,       media)
exec("XF86AudioLowerVolume",  p.volumeDown,     media)
exec("XF86AudioMute",         p.toggleVolume,   media)
exec("XF86AudioMicMute",      p.toggleMic,      media)
exec("XF86MonBrightnessUp",   p.brightnessUp,   media)
exec("XF86MonBrightnessDown", p.brightnessDown, media)

-- Requires playerctl
exec("XF86AudioNext",  "playerctl next",       { locked = true })
exec("XF86AudioPause", "playerctl play-pause", { locked = true })
exec("XF86AudioPlay",  "playerctl play-pause", { locked = true })
exec("XF86AudioPrev",  "playerctl previous",   { locked = true })

-- Focus and move windows (vim keys)
local dirs = { H = "left", L = "right", K = "up", J = "down" }
for key, dir in pairs(dirs) do
    hl.bind(mod .. " + " .. key,             hl.dsp.focus({ direction = dir }))
    hl.bind(mod .. " + SHIFT + " .. key,     hl.dsp.window.move({ direction = dir }), { description = "Move window " .. dir })
end

-- Cycle / swap windows with < >
hl.bind(mod .. " + COMMA",          hl.dsp.window.cycle_next({ next = false }),  { description = "Cycle to previous window" })
hl.bind(mod .. " + PERIOD",         hl.dsp.window.cycle_next({ next = true }),   { description = "Cycle to next window" })
hl.bind(mod .. " + SHIFT + COMMA",  hl.dsp.window.swap({ prev = true }),        { description = "Swap with previous window" })
hl.bind(mod .. " + SHIFT + PERIOD", hl.dsp.window.swap({ next = true }),         { description = "Swap with next window" })

-- Window controls
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + MINUS",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + SHIFT + MINUS", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + SLASH", hl.dsp.workspace.swap_monitors({ monitor1 = "eDP-1", monitor2 = "HDMI-A-1" }))
exec(mod .. " + EQUAL", p.toggleDisplay)

-- Workspaces 1-10 (key 0 = workspace 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
