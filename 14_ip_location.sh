#!/bin/bash
# 14. Get the location of an IP address (uses the free ipinfo.io service)
# Usage: bash 14_ip_location.sh [ip]   (leave blank for your own public IP)

ip="$1"
[ -z "$ip" ] && read -rp "Enter an IPv4 address (blank = your own): " ip

if ! command -v curl > /dev/null; then
  echo "Error: curl not found. Install it with: sudo apt install curl"
  exit 1
fi

if [ -n "$ip" ]; then
  if ! [[ $ip =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
    echo "Error: '$ip' is not a valid IPv4 address."
    exit 1
  fi
  for octet in "${BASH_REMATCH[@]:1}"; do
    if (( octet > 255 )); then
      echo "Error: '$ip' is not a valid IPv4 address."
      exit 1
    fi
  done
  url="https://ipinfo.io/$ip/json"
else
  url="https://ipinfo.io/json"
fi

data=$(curl -s --max-time 10 "$url")
if [ -z "$data" ]; then
  echo "Error: no response. Check your internet connection."
  exit 1
fi

if echo "$data" | grep -q '"bogon"'; then
  echo "$ip is a private/reserved address, so it has no public location."
  exit 0
fi

get() { echo "$data" | grep -o "\"$1\": *\"[^\"]*\"" | head -1 | cut -d'"' -f4; }

echo "IP address : $(get ip)"
echo "City       : $(get city)"
echo "Region     : $(get region)"
echo "Country    : $(get country)"
echo "Coordinates: $(get loc)"
echo "ISP/Org    : $(get org)"
echo "Timezone   : $(get timezone)"
