#!/bin/bash

# Get random wallpaper from your collection
WALLPAPER_DIR="$HOME/.local/share/wallpapers/"
RANDOM_IMAGE=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

# Kill existing swaybg and start new one
pkill swaybg
swaybg --image "$RANDOM_IMAGE" --mode fill &

# Optional: Add to sway socket if you need IPC
# swaymsg "output * bg $RANDOM_IMAGE fill"
