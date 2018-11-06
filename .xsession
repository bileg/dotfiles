#!/bin/bash

#export _JAVA_AWT_WM_NONREPARENTING=1

export PATH=$PATH:/home/bileg/.notion/bin
export PATH=$PATH:/home/bileg/gevtools/idea-IC/bin
export PATH=$PATH:/home/bileg/gevtools/pycharm-community/bin

export XDG_CURRENT_DESKTOP=Unity       # unity-control-center

export NO_AT_BRIDGE=1   # get rid of warning messages: "Couldn't connect to accessibility bus: Failed to connect to socket ..."

#xrandr -o left

xbinkeys &
#/home/bileg/.notion/low_battery3.sh &
#convert -append WDF_1737988.png WDF_1737988.png     WDF_1737988_stacked.png
xautolock -time 10 -locker "i3lock -i /home/bileg/.notion/WDF_1737988_4x.png" -nowlocker "i3lock -i /home/bileg/.notion/WDF_1737988_4x.png" -detectsleep -corners 000+ -cornerdelay 30 &
#dunst -conf /home/bileg/.notion/dunstrc &

# https://wiki.archlinux.org/index.php/Mouse_acceleration
# To get the current values, use: xset q | grep -A 1 Pointer
# To set new values, type: xset m acceleration threshold
#xset m 1 4

#exec openbox-session
exec notion

