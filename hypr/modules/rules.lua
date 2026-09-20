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

-- Popup bluetooth manager (see scripts/bluetooth-popup.sh)
hl.window_rule({
    name  = "bluetooth-popup",
    match = { class = "^(blueberry\\.py)$" },
    float = true,
    move  = "1310 42",
    size  = "600 400",
})

hl.layer_rule({
    name  = "waybar-blur",
    match = { namespace = "waybar" },
    blur  = true,
})
