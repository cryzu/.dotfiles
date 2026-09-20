-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Waybar click popups (see scripts/*-popup.sh): floated under the bar and
-- slid in from the top edge, so they emerge from behind the (top-layer) bar.
local popups = {
    { name = "audio-popup",     match = { title = "^wiremix$" } },
    { name = "network-popup",   match = { class = "^nm-connection-editor$" } },
    { name = "bluetooth-popup", match = { class = "^blueberry\\.py$" } },
}
for _, popup in ipairs(popups) do
    hl.window_rule({
        name      = popup.name,
        match     = popup.match,
        float     = true,
        move      = "1310 42",
        size      = "600 400",
        animation = "slide top",
    })
end

hl.layer_rule({
    name  = "waybar-blur",
    match = { namespace = "waybar" },
    blur  = true,
})
