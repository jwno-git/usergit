#!/bin/bash

CHOICE=$(wofi --dmenu --prompt -y 5 -x 1220 "SSH to:" < ~/.config/wofi/ssh_hosts)

if [ -n "$CHOICE" ]; then
    terminator -e "sh -c '$CHOICE'" &
    disown
fi

