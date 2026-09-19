#!/usr/bin/env bash

# Path to your theme-switching script
THEME_SCRIPT="$HOME/.config/scripts/switch-theme.sh"

# Path to themes
THEMES_DIR="$HOME/.dotfiles/.dotter/themes"

# Get list of available themes (strip .toml)
THEMES=$(ls "$THEMES_DIR" | sed 's/\.toml$//')

# Use rofi to select one
CHOSEN_THEME=$(echo "$THEMES" | rofi -dmenu -p "🎨 Select theme")

# If user selected a theme, run the script
if [ -n "$CHOSEN_THEME" ]; then
    "$THEME_SCRIPT" "$CHOSEN_THEME"
fi
