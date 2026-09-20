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
-- slid in from the right edge.
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
        move      = "1310 48",
        size      = "600 400",
        animation = "slide right",
    })
end

hl.layer_rule({
    name  = "waybar-blur",
    match = { namespace = "waybar" },
    blur  = true,
})

-- Dunst notifications slide in from the right, like the waybar popups.
hl.layer_rule({
    name      = "notifications-slide",
    match     = { namespace = "^notifications$" },
    animation = "slide right",
})
