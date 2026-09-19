// ----------------------
// Utility functions
// ----------------------

fn reverse(string) {
    if string.len == 1 { return string; }
    return reverse(string.sub_string(1)) + string[0];
}

fn hexToNum(hex) {
    let base = 16;
    let hexValue = #{
        "0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
        "a": 10, "b": 11, "c": 12, "d": 13, "e": 14, "f": 15,
        "A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15
    };

    let power = 0;
    let num = 0;
    for char in reverse(hex).chars() {
        num += hexValue[char.to_string()] * (base ** power);
        power += 1;
    }
    return num;
}

// ----------------------
// Core conversion logic
// ----------------------

fn hex_to_rgba(hex) {
    if hex.starts_with("#") {
        hex = hex.sub_string(1);
    }

    // Expand shorthand (3 or 4)
    if hex.len == 3 {
        hex = "" + hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
    } else if hex.len == 4 {
        hex = "" + hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2] + hex[3] + hex[3];
    }

    // Validate length
    if hex.len != 6 && hex.len != 8 {
        throw "Invalid hex length: must be 3, 4, 6, or 8 characters (excluding '#')";
    }

    let r = hexToNum(hex.sub_string(0, 2));
    let g = hexToNum(hex.sub_string(2, 2));
    let b = hexToNum(hex.sub_string(4, 2));
    let a = if hex.len == 8 { hexToNum(hex.sub_string(6, 2)) / 255.0 } else { 1.0 };

    return [r, g, b, a];
}

fn rgba_to_hsla(rgba) {
    let r = rgba[0] / 255.0;
    let g = rgba[1] / 255.0;
    let b = rgba[2] / 255.0;
    let a = rgba[3];

    let max = r.max(g).max(b);
    let min = r.min(g).min(b);
    let h = 0.0;
    let s = 0.0;
    let l = (max + min) / 2.0;

    if max != min {
        let d = max - min;
        s = if l > 0.5 { d / (2.0 - max - min) } else { d / (max + min) };

        h = if max == r {
            (g - b) / d + (if g < b { 6.0 } else { 0.0 })
        } else if max == g {
            (b - r) / d + 2.0
        } else {
            (r - g) / d + 4.0
        };
        h /= 6.0;
    }

    return [h * 360.0, s * 100.0, l * 100.0, a];
}

// ----------------------
// Main entry point
// ----------------------

let hex = params[0];
let mode = if params.len() > 1 { params[1] } else { "hex" };

let rgba = hex_to_rgba(hex);
let hsla = rgba_to_hsla(rgba);

if mode == "hex" {
    // Handle 4- or 8-digit hex -> remove alpha
    if hex.starts_with("#") {
        hex = hex.sub_string(1);
    }

    if hex.len == 4 {
        // Convert shorthand #RGBA → #RRGGBB
        "#" + hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2]
    } else if hex.len == 8 {
        // Convert #RRGGBBAA → #RRGGBB
        "#" + hex.sub_string(0, 6)
    } else {
        // Just return the normalized 6-digit form
        if hex.len == 3 {
            "#" + hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2]
        } else {
            "#" + hex
        }
    }
} else if mode == "rgb" {
    "rgb(" + rgba[0] + "," + rgba[1] + "," + rgba[2] + ")"
} else if mode == "rgba" {
    "rgba(" + rgba[0] + "," + rgba[1] + "," + rgba[2] + "," + rgba[3] + ")"
} else if mode == "hsl" {
    "hsl(" + hsla[0].to_int() + "," + hsla[1].to_int() + "%," + hsla[2].to_int() + "%)"
} else if mode == "hsla" {
    "hsla(" + hsla[0].to_int() + "," + hsla[1].to_int() + "%," + hsla[2].to_int() + "%," + hsla[3] + ")"
} else if mode == "r" {
    rgba[0]
} else if mode == "g" {
    rgba[1]
} else if mode == "b" {
    rgba[2]
} else if mode == "a" {
    rgba[3]
} else if mode == "h" {
    hsla[0]
} else if mode == "s" {
    hsla[1]
} else if mode == "l" {
    hsla[2]
} else {
    throw "Invalid mode: must be one of hex, rgb, rgba, hsl, hsla, r, g, b, a, h, s, l";
}
