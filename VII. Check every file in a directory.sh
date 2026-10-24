#!/bin/bash
read -rp "Enter a directory path: " dir

if [ ! -d "$dir" ]; then
  echo "'$dir' is not a directory."
  exit 1
fi

shopt -s nullglob
for item in "$dir"/*; do
  if [ -f "$item" ]; then
    echo "$(basename "$item") is a regular file."
  elif [ -d "$item" ]; then
    echo "$(basename "$item") is a directory."
  else
    echo "$(basename "$item") is another type of file."
  fi
  ls -ld "$item"
  echo
done
