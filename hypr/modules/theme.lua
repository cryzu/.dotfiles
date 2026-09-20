-- Rendered by dotter from the active theme (.dotter/theme.toml).

hl.config({
    general = {
        gaps_in  = {{ gaps }},
        gaps_out = {{ math 2 "*" gaps }},
        col = {
            active_border   = "{{ color_conv accent "rgb" }}",
            inactive_border = "{{ color_conv accent_inactive "rgba" }}",
        },
    },
    decoration = {
        rounding = {{ rounding }},
        shadow   = { color = "rgba(1a1a1aee)" },
    },
})
