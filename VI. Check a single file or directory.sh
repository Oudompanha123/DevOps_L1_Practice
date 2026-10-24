#!/bin/bash
read -rp "Enter a file or directory name: " item

if [ ! -e "$item" ]; then
  echo "'$item' does not exist."
  exit 1
fi

if [ -f "$item" ]; then
  echo "$item is a regular file."
elif [ -d "$item" ]; then
  echo "$item is a directory."
else
  echo "$item is another type of file."
fi

ls -ld "$item"
