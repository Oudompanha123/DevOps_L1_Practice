#!/bin/bash
# 1. Output a specified directory's size
# Usage: bash 01_dir_size.sh [directory]

dir="$1"
[ -z "$dir" ] && read -rp "Enter directory path: " dir

if [ ! -d "$dir" ]; then
  echo "Error: '$dir' is not a directory."
  exit 1
fi

size=$(du -sh "$dir" 2>/dev/null | cut -f1)
echo "Total size of $dir: $size"
echo
echo "Largest items inside:"
du -sh "$dir"/* 2>/dev/null | sort -hr | head -5
