#!/bin/bash
# 6. Gather detailed server information and save it to a report file
# Usage: bash 06_gather_server_info.sh

out="server_info_$(hostname)_$(date +%Y%m%d_%H%M%S).txt"

section() { echo; echo "===== $1 ====="; }
run() {
  if command -v "$1" > /dev/null 2>&1; then "$@" 2>/dev/null
  else echo "($1 is not installed)"; fi
}

{
  echo "Server information report - $(date)"

  section "SYSTEM"
  echo "Hostname : $(hostname)"
  echo "OS       : $(. /etc/os-release && echo "$PRETTY_NAME")"
  echo "Kernel   : $(uname -r)"
  echo "Uptime   : $(uptime -p)"

  section "CPU"
  run lscpu | grep -E '^(Model name|CPU\(s\)|Thread|Core|Socket|Architecture)'

  section "MEMORY"
  free -h

  section "DISK USAGE"
  df -h -x tmpfs -x devtmpfs

  section "NETWORK INTERFACES"
  run ip -brief address

  section "LISTENING PORTS"
  run ss -tuln

  section "TOP 5 PROCESSES BY CPU"
  ps aux --sort=-%cpu | head -6

  section "TOP 5 PROCESSES BY MEMORY"
  ps aux --sort=-%mem | head -6

  section "LOGGED-IN USERS"
  who
} | tee "$out"

echo
echo "Report saved to: $out"
