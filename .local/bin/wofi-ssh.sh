#!/bin/bash

CHOICE=$(wofi --dmenu --prompt "SSH to:" < ~/.config/wofi/ssh_hosts)

if [ -n "$CHOICE" ]; then
    terminator -e "sh -c '$CHOICE'" &
    disown
fi

