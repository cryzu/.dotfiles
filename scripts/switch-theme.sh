#!/usr/bin/env bash
# Usage: switch-theme.sh [--restart app,app | --restart-all] <theme-name>
#
# Deploys the theme and reloads everything that supports a live reload.
# Apps that can only pick a theme up by restarting (firefox, dolphin) are
# left running unless you opt in with --restart.
set -e

DOTFILES_DIR="$HOME/.dotfiles"
THEMES_DIR="$DOTFILES_DIR/.dotter/themes"
TARGET_FILE="$DOTFILES_DIR/.dotter/theme.toml"
RESTARTABLE=(firefox dolphin)

list_themes() {
    ls "$THEMES_DIR" | sed 's/\.toml$//'
}

# ----------------------
# Arguments
# ----------------------
RESTART=()
while [ $# -gt 0 ]; do
    case "$1" in
        --restart)     IFS=, read -ra RESTART <<< "$2"; shift 2 ;;
        --restart-all) RESTART=("${RESTARTABLE[@]}"); shift ;;
        -*)            echo "Unknown option: $1"; exit 1 ;;
        *)             THEME="$1"; shift ;;
    esac
done

if [ -z "$THEME" ]; then
    echo "Usage: $0 [--restart app,app | --restart-all] <theme-name>"
    echo "Restartable apps: ${RESTARTABLE[*]}"
    echo "Available themes:"
    list_themes
    exit 1
fi

THEME_FILE="$THEMES_DIR/$THEME.toml"
if [ ! -f "$THEME_FILE" ]; then
    echo "Error: Theme '$THEME' not found in $THEMES_DIR"
    echo "Available themes:"
    list_themes
    exit 1
fi

# ----------------------
# Deploy
# ----------------------
cp "$THEME_FILE" "$TARGET_FILE"
cd "$DOTFILES_DIR"
dotter deploy -f -y -q

echo "✅ Theme switched to '$THEME'"

# ----------------------
# Live reloads (nothing gets closed)
# ----------------------
if command -v hyprctl &>/dev/null && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "🔄 Reloading Hyprland..."
    hyprctl reload >/dev/null

    if pgrep -x hyprpaper &>/dev/null; then
        echo "🔄 Setting wallpaper..."
        WALLPAPER=$(sed -n 's/^wallpaper *= *"\(.*\)"/\1/p' "$TARGET_FILE")
        for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
            hyprctl hyprpaper wallpaper "$monitor,$HOME/.config/themes/backgrounds/$WALLPAPER,cover" >/dev/null
        done
    fi
fi

if pgrep -x waybar &>/dev/null; then
    echo "🔄 Reloading Waybar..."
    pkill -USR2 -x waybar
fi

if command -v dunstctl &>/dev/null && pgrep -x dunst &>/dev/null; then
    echo "🔄 Reloading Dunst..."
    dunstctl reload
fi

if pgrep -x ghostty &>/dev/null; then
    echo "🔄 Reloading Ghostty..."
    pkill -USR2 -x ghostty
fi

# ----------------------
# Opt-in restarts
# ----------------------
NEEDS_RESTART=()
for app in "${RESTARTABLE[@]}"; do
    pgrep -x "$app" &>/dev/null || continue
    if [[ " ${RESTART[*]} " == *" $app "* ]]; then
        echo "🔄 Restarting $app..."
        pkill -x "$app"
        while pgrep -x "$app" &>/dev/null; do sleep 0.1; done
        uwsm app -- "$app" &>/dev/null &
    else
        NEEDS_RESTART+=("$app")
    fi
done

echo "✅ Reloaded programs"
if [ ${#NEEDS_RESTART[@]} -gt 0 ]; then
    echo "ℹ️  Restart to fully apply: ${NEEDS_RESTART[*]} (or rerun with --restart-all)"
fi
