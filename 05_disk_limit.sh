#!/bin/bash
# 5. Check if disk space usage crosses a limit
# Usage: bash 05_disk_limit.sh [limit_percent]   (default 80)

limit="${1:-80}"
if ! [[ $limit =~ ^[0-9]+$ ]] || (( limit > 100 )); then
  echo "Error: limit must be a number from 0 to 100."
  exit 1
fi

echo "Disk usage limit: ${limit}%"
echo
alert=0

while read -r fs size used avail pct mount; do
  usage="${pct%\%}"
  [[ $usage =~ ^[0-9]+$ ]] || continue
  if (( usage >= limit )); then
    echo "WARNING: $mount ($fs) is at ${usage}%"
    alert=1
  else
    echo "OK     : $mount is at ${usage}%"
  fi
done < <(df -P -x tmpfs -x devtmpfs 2>/dev/null | awk 'NR>1')

echo
if (( alert )); then
  echo "One or more disks crossed the limit."
  exit 1
else
  echo "All disks are within the limit."
fi
