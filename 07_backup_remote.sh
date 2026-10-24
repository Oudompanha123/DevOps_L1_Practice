#!/bin/bash
# 7. Back up a local file to a remote server (uses scp over SSH)
# Usage: bash 07_backup_remote.sh <file> <user@host:/remote/path>
# Example: bash 07_backup_remote.sh notes.txt panha@192.168.1.10:/home/panha/backups

src="$1"
dest="$2"
[ -z "$src" ]  && read -rp "Local file to back up: " src
[ -z "$dest" ] && read -rp "Remote destination (user@host:/path): " dest

if [ ! -f "$src" ]; then
  echo "Error: '$src' is not a file."
  exit 1
fi
if [[ $dest != *@*:* ]]; then
  echo "Error: destination must look like user@host:/path"
  exit 1
fi
if ! command -v scp > /dev/null; then
  echo "Error: scp not found. Install it with: sudo apt install openssh-client"
  exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)
backup_name="$(basename "$src")_$timestamp"

echo "Copying $src to $dest/$backup_name ..."
if scp "$src" "$dest/$backup_name"; then
  echo "Backup successful."
else
  echo "Backup FAILED. Check the host, path, and your SSH login."
  exit 1
fi
