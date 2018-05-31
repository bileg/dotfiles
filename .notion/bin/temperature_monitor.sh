#!/bin/sh

# from https://bbs.archlinux.org/viewtopic.php?id=60522
#    install notification-daemon package
#    install tango-icon-theme 

SLEEP=15
THRESHOLD=60
ICON=/usr/share/icons/Tango/48x48/status/gtk-dialog-warning.png

while :
do
    temp=`cat /proc/acpi/thermal_zone/THRM/temperature | sed 's/[^0-9]//g'`
    if [ $temp -gt $THRESHOLD ] && [ "$DISPLAY" = ":0.0" ]; then
        notify-send "WARNING! High Temperature!" \
            "Current system temperature is $temp" \
            -i "$ICON" \
            -t 150000 \
            -u critical
    fi
    sleep $SLEEP
done
