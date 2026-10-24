#!/bin/bash
# 12. Check if a number is prime
# Usage: bash 12_prime.sh [number]

num="$1"
[ -z "$num" ] && read -rp "Enter a number: " num

if ! [[ $num =~ ^[0-9]+$ ]]; then
  echo "Error: please enter a non-negative whole number."
  exit 1
fi
num=$((10#$num))

if (( num < 2 )); then
  echo "$num is NOT prime."
  exit 0
fi

for (( i = 2; i * i <= num; i++ )); do
  if (( num % i == 0 )); then
    echo "$num is NOT prime (divisible by $i)."
    exit 0
  fi
done

echo "$num is prime."
