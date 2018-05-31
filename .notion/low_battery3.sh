#!/bin/bash

# https://bbs.archlinux.org/viewtopic.php?pid=391396
# sudo pacman -S acpi

# Configuration
interval=120    #in seconds
critical_level=25    #percent
icon="/usr/share/icons/Tango/48x48/devices/battery.png"     #notification icon

while true
do
    if [ "$(acpi -a | grep -o off)" == "off" ]; then
        battery_level=`acpi -b | sed 's/.*[dg], //g;s/\%,.*//g'`
        [ $battery_level -le $critical_level ] && \
        notify-send -u critical -i "$icon" -t 15000 \
        "Battery level is low!" "Only $battery_level% of the charge remains."
    fi
    sleep $interval
done
