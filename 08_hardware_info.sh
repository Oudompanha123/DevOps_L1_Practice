#!/bin/bash
# 8. Show hardware information on Linux
# Usage: bash 08_hardware_info.sh   (use sudo for BIOS/motherboard details)

section() { echo; echo "===== $1 ====="; }
run() {
  if command -v "$1" > /dev/null 2>&1; then "$@" 2>/dev/null
  else echo "($1 is not installed)"; fi
}

section "CPU"
run lscpu | grep -E '^(Model name|Vendor ID|Architecture|CPU\(s\)|Thread|Core|Socket|CPU max MHz|L3 cache)'

section "MEMORY"
free -h

section "BLOCK DEVICES (DISKS)"
run lsblk -o NAME,SIZE,TYPE,MOUNTPOINT

section "PCI DEVICES"
run lspci

section "USB DEVICES"
run lsusb

section "BIOS / MOTHERBOARD"
if [ "$EUID" -eq 0 ]; then
  run dmidecode -t system -t baseboard -t bios | grep -E 'Manufacturer|Product Name|Version|Release Date'
else
  echo "(run with sudo to see BIOS and motherboard details)"
fi
