#!/bin/sh
# exit hyprland with force
notify-send -a Hyprland "Exiting Hyprland..." -t 3500

# echo "Hyprland exit" | systemd-cat -t hyprexit -p info
# hyprctl dispatch exit &
#
# sleep 10
# echo "Hyprland failed to exit" | systemd-cat -t hyprexit -p err
# killall -9 Hyprland
