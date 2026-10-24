#!/bin/bash
# 2. Evaluate the status of a file or directory
# Usage: bash 02_file_status.sh [path]

path="$1"
[ -z "$path" ] && read -rp "Enter a file or directory path: " path

if [ ! -e "$path" ]; then
  echo "Status: '$path' does not exist."
  exit 1
fi

yn() { if "$@"; then echo "yes"; else echo "no"; fi; }

if [ -f "$path" ]; then
  type="regular file"
  empty=$(yn test ! -s "$path")
elif [ -d "$path" ]; then
  type="directory"
  empty=$(yn test -z "$(ls -A "$path")")
else
  type="other (device, socket, pipe...)"
  empty="n/a"
fi

echo "Path          : $path"
echo "Type          : $type"
echo "Size          : $(du -sh "$path" 2>/dev/null | cut -f1)"
echo "Empty         : $empty"
echo "Owner:Group   : $(stat -c '%U:%G' "$path")"
echo "Permissions   : $(stat -c '%A (%a)' "$path")"
echo "Readable      : $(yn test -r "$path")"
echo "Writable      : $(yn test -w "$path")"
echo "Executable    : $(yn test -x "$path")"
echo "Last modified : $(stat -c '%y' "$path" | cut -d. -f1)"
echo
ls -ld "$path"
