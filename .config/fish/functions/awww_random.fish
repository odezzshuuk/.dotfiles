#!/usr/bin/env fish

if type -q awww
    echo "awww is not installed. Please install awww to use this script."
    exit 1
end

set WALLPAPER_DIR "$HOME/.local/share/wallpapers"
set CURRENT_WALL (awww query | awk -F'image: ' '{print $2}')

# Get a random wallpaper that is not the current one
set WALLPAPER (find "$WALLPAPER_DIR" -type f ! -name (basename "$CURRENT_WALL") | shuf -n 1)

# Apply the selected wallpaper
awww img "$WALLPAPER"
