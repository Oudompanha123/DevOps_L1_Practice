#!/bin/bash
# 9. Show the CPU temperature
# Usage: bash 09_cpu_temp.sh
# Note: WSL and most virtual machines cannot read hardware sensors.

found=0

for zone in /sys/class/thermal/thermal_zone*; do
  [ -r "$zone/temp" ] || continue
  name=$(cat "$zone/type" 2>/dev/null)
  temp=$(cat "$zone/temp")
  awk -v t="$temp" -v n="$name" 'BEGIN { printf "%-20s %.1f°C\n", n, t/1000 }'
  found=1
done

if (( ! found )) && command -v sensors > /dev/null; then
  sensors
  found=1
fi

if (( ! found )); then
  echo "Could not read the CPU temperature."
  echo "On real Linux, install sensors with: sudo apt install lm-sensors"
  echo "On WSL or a virtual machine, temperature sensors are not available."
  exit 1
fi
