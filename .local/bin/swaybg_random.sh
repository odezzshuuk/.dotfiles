#!/bin/bash

# Get random wallpaper from your collection
WALLPAPER_DIR="$HOME/.local/share/wallpapers/"
RANDOM_IMAGE=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

echo "Setting wallpaper to: $RANDOM_IMAGE"
# Kill existing swaybg and start new one
EXISTED_SWAYBG_PIDS=$(pidof swaybg | sed 's/ /,/g')
echo "Existing swaybg PIDs: $EXISTED_SWAYBG_PIDS"
swaybg --image "$RANDOM_IMAGE" --mode fill &

if [ -n "$EXISTED_SWAYBG_PIDS" ]; then
    pkill -p $EXISTED_SWAYBG_PIDS
fi

