#!/usr/bin/env bash

current_zoom=$(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}')

if awk "BEGIN {exit !($current_zoom == 1.0)}"; then
    hyprctl keyword cursor:zoom_factor 2.0
else
    hyprctl keyword cursor:zoom_factor 1.0
fi
