#!/bin/bash
# 13. Convert a decimal number to binary
# Usage: bash 13_dec_to_bin.sh [number]

num="$1"
[ -z "$num" ] && read -rp "Enter a decimal number: " num

if ! [[ $num =~ ^[0-9]+$ ]]; then
  echo "Error: please enter a non-negative whole number."
  exit 1
fi

n=$((10#$num))
binary=""

if (( n == 0 )); then
  binary="0"
fi

while (( n > 0 )); do
  binary="$(( n % 2 ))$binary"
  n=$(( n / 2 ))
done

echo "Decimal $num = Binary $binary"
