#!/bin/bash

# 1. Get Battery (Icon + Percentage)
bat_pct=$(cat /sys/class/power_supply/BAT0/capacity)
bat_status=$(cat /sys/class/power_supply/BAT0/status)
# Use a skull for the battery because... Berserk.
bat_icon="󱚟" 

# 2. Get Network (Check if connected to wifi or ethernet)
# This looks for any 'up' interface that isn't loopback
network=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
if [ -z "$network" ]; then
    network_status="󰤭 Offline"
else
    network_status="󰖟 $network"
fi

# 3. Get Time and Date
date_time=$(date +'%Y-%m-%d  %H:%M')

# 4. Format the output with your Crimson variables in mind
# Note: We use spaces and pipes (|) to keep it clean
echo "$network_status  |  $bat_icon $bat_pct% ($bat_status)  |  $date_time"

