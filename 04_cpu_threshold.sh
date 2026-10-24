#!/bin/bash
# 4. Report if CPU usage exceeds a threshold
# Usage: bash 04_cpu_threshold.sh [threshold_percent]   (default 80)

threshold="${1:-80}"
if ! [[ $threshold =~ ^[0-9]+$ ]] || (( threshold > 100 )); then
  echo "Error: threshold must be a number from 0 to 100."
  exit 1
fi

# Read CPU counters twice, 1 second apart, and compare
read -r _ u1 n1 s1 i1 w1 q1 sq1 st1 _ < /proc/stat
sleep 1
read -r _ u2 n2 s2 i2 w2 q2 sq2 st2 _ < /proc/stat

total1=$((u1 + n1 + s1 + i1 + w1 + q1 + sq1 + st1))
total2=$((u2 + n2 + s2 + i2 + w2 + q2 + sq2 + st2))
idle_diff=$(( (i2 + w2) - (i1 + w1) ))
total_diff=$((total2 - total1))
usage=$(( 100 * (total_diff - idle_diff) / total_diff ))

echo "Current CPU usage: ${usage}%  (threshold: ${threshold}%)"

if (( usage > threshold )); then
  echo "ALERT: CPU usage has exceeded the threshold!"
  echo "Top 5 processes by CPU:"
  ps aux --sort=-%cpu | head -6
  exit 1
else
  echo "OK: CPU usage is below the threshold."
fi
