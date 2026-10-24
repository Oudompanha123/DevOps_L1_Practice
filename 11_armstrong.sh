#!/bin/bash
# 11. Check if a number is an Armstrong number
# (sum of each digit raised to the number of digits equals the number, e.g. 153 = 1^3 + 5^3 + 3^3)
# Usage: bash 11_armstrong.sh [number]

num="$1"
[ -z "$num" ] && read -rp "Enter a number: " num

if ! [[ $num =~ ^[0-9]+$ ]]; then
  echo "Error: please enter a non-negative whole number."
  exit 1
fi

num=$((10#$num))   # remove leading zeros
digits=${#num}
sum=0
for (( i = 0; i < digits; i++ )); do
  d=${num:i:1}
  sum=$(( sum + d ** digits ))
done

if (( sum == num )); then
  echo "$num is an Armstrong number."
else
  echo "$num is NOT an Armstrong number (sum of powers = $sum)."
fi
