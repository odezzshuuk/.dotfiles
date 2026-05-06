#!/bin/bash

hyprpaper_random() {
    local WALLPAPER_DIR="$HOME/.local/share/wallpapers/"
    local CURRENT_WALL=$(hyprctl hyprpaper listloaded)

    # Get a random wallpaper that is not the current one
    local WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

    # Apply the selected wallpaper
    hyprctl hyprpaper wallpaper ",$WALLPAPER" > /dev/null
    if type matugen >/dev/null 2>&1; then
      matugen image "$WALLPAPER" > /dev/null
    fi
}

hyprpaper_random
