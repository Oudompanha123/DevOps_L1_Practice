#!/bin/bash
# 3. Report server-related information (quick summary)
# Usage: bash 03_server_report.sh

echo "========== SERVER REPORT =========="
echo "Hostname     : $(hostname)"
echo "OS           : $(. /etc/os-release && echo "$PRETTY_NAME")"
echo "Kernel       : $(uname -r)"
echo "Architecture : $(uname -m)"
echo "Date/Time    : $(date)"
echo "Uptime       : $(uptime -p)"
echo "IP address   : $(hostname -I | awk '{print $1}')"
echo "Load average : $(cut -d' ' -f1-3 /proc/loadavg)"
echo "CPU cores    : $(nproc)"
echo "Memory       : $(free -h | awk '/^Mem:/ {print $3 " used / " $2 " total"}')"
echo "Disk (/)     : $(df -h / | awk 'NR==2 {print $3 " used / " $2 " total (" $5 ")"}')"
echo "Users online : $(who | wc -l)"
echo "==================================="
