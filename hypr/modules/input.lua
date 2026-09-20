-- https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
    input = {
        kb_layout  = "ee(us), ee",
        kb_options = "grp:alt_shift_toggle",

        follow_mouse = 1,
        sensitivity  = 0.1, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",

        touchpad = {
            natural_scroll = true,
            scroll_factor  = 0.2,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })
