#!/usr/bin/env fish

set WALLPAPER_DIR "$HOME/.config/hypr/wallpapers/"
set CURRENT_WALL (swww query | awk -F'image: ' '{print $2}')

# Get a random wallpaper that is not the current one
set WALLPAPER (find "$WALLPAPER_DIR" -type f ! -name (basename "$CURRENT_WALL") | shuf -n 1)

# Apply the selected wallpaper
swww img "$WALLPAPER"
