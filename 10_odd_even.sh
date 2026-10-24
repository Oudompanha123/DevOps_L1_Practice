#!/bin/bash
# 10. Check if a number from standard input is odd or even
# Usage: bash 10_odd_even.sh

read -rp "Enter a number: " num

if ! [[ $num =~ ^-?[0-9]+$ ]]; then
  echo "Error: '$num' is not a whole number."
  exit 1
fi

if (( num % 2 == 0 )); then
  echo "$num is even."
else
  echo "$num is odd."
fi
