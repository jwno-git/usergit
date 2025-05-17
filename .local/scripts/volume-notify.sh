##!/bin/bash

# Change the volume
pactl set-sink-volume @DEFAULT_SINK@ "$1"

# Get the new volume
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)

# Send a notification
dunstify -r 91190 -u low "Volume: $VOLUME"
