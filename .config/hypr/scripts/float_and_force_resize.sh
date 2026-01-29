#!/usr/bin/env bash

floating=$(hyprctl activewindow | grep "floating:" | awk '{print $2}')

if [ "$floating" = "1" ]; then
    # If floating, toggle to tile
    hyprctl dispatch togglefloating
else
    # If not floating, float it and resize to 800x600
    hyprctl dispatch togglefloating
    hyprctl dispatch resizeactive exact 70% 70%
    hyprctl dispatch centerwindow
fi
