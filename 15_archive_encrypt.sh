#!/bin/bash
# 15. Archive a path into a file and encrypt it (tar + gpg AES-256)
# Usage: bash 15_archive_encrypt.sh [path]
# To restore later: gpg -d FILE.tar.gz.gpg | tar -xzf -

src="$1"
[ -z "$src" ] && read -rp "Enter the file or directory to archive: " src

if [ ! -e "$src" ]; then
  echo "Error: '$src' does not exist."
  exit 1
fi
if ! command -v gpg > /dev/null; then
  echo "Error: gpg not found. Install it with: sudo apt install gnupg"
  exit 1
fi

name=$(basename "$src")
archive="${name}_$(date +%Y%m%d_%H%M%S).tar.gz"

echo "Creating archive $archive ..."
if ! tar -czf "$archive" -C "$(dirname "$src")" "$name"; then
  echo "Error: failed to create the archive."
  rm -f "$archive"
  exit 1
fi

echo "Encrypting (you will be asked for a passphrase twice) ..."
export GPG_TTY=$(tty)
if gpg --symmetric --cipher-algo AES256 -o "$archive.gpg" "$archive"; then
  rm -f "$archive"
  echo "Done. Encrypted file: $archive.gpg"
  echo "To restore: gpg -d $archive.gpg | tar -xzf -"
else
  rm -f "$archive"
  echo "Error: encryption failed."
  exit 1
fi
