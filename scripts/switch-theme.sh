#!/usr/bin/env bash
set -e

# ----------------------
# Path setup
# ----------------------
DOTFILES_DIR="$HOME/.dotfiles"
DOTTER_DIR="$HOME/.dotfiles/.dotter"
THEMES_DIR="$DOTTER_DIR/themes"
TARGET_FILE="$DOTTER_DIR/theme.toml"

# ----------------------
# Get argument
# ----------------------
THEME="$1"

# ----------------------
# Usage check
# ----------------------
if [ -z "$THEME" ]; then
    echo "Usage: $0 <theme-name>"
    echo "Available themes:"
    ls "$THEMES_DIR" | sed 's/\.toml$//'
    exit 1
fi

# ----------------------
# Check theme exists
# ----------------------
THEME_FILE="$THEMES_DIR/$THEME.toml"
if [ ! -f "$THEME_FILE" ]; then
    echo "Error: Theme '$THEME' not found in $THEMES_DIR"
    echo "Available themes:"
    ls "$THEMES_DIR" | sed 's/\.toml$//'
    exit 1
fi

# ----------------------
# Copy theme and deploy
# ----------------------
cp "$THEME_FILE" "$TARGET_FILE"
cd "$DOTFILES_DIR"
dotter deploy -f

echo "✅ Theme switched to '$THEME'"
echo "Copied $THEME_FILE → $TARGET_FILE"

# ----------------------
# Reload programs
# ----------------------
if pgrep hyprpaper &>/dev/null; then
    echo "🔄 Reloading Hyprpaper..."
    pkill hyprpaper
    hyprpaper &
fi

# if pgrep linux-wallpaper &>/dev/null; then
#     echo "🔄 Killing Wallpaper Engine..."
#     pkill linux-wallpaper
# fi
# if ! (({{wallpaper-engine-wp-id}} == 0)); then
#     echo "🔄 Reloading Wallpaper Engine..."
#     uwsm app -- $HOME/.config/scripts/run-wallpaperengine.sh &
# fi

if command -v dunstctl &>/dev/null; then
    echo "🔄 Reloading Dunst..."
    dunstctl reload || (pkill dunst && dunst &)
fi

if pgrep waybar &>/dev/null; then
    echo "🔄 Reloading Waybar..."
    pkill waybar
    waybar &
fi

if pgrep firefox &>/dev/null; then
    echo "🔄 Reloading Firefox..."
    pkill firefox
    firefox &
fi

if pgrep dolphin &>/dev/null; then
    echo "🔄 Restarting Dolphin..."
    pkill dolphin
    dolphin &
fi

if pgrep ghostty &>/dev/null; then
    echo "🔄 Restarting Ghostty..."
    pkill ghostty
    ghostty &
fi


echo "✅ Reloaded programs"
