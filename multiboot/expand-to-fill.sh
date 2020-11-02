#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
	exec sudo bash "$0" "$@"
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ -f ../local-config ]; then
	source ../local-config
fi

if [ -z "$SDCARD" ]; then
	echo "No block device specified for the SDCARD. Exitting."
	exit 1
fi

echo ", +" | sfdisk -N 2 "$SDCARD"

mount "$SDCARD_P2" /mnt
btrfs filesystem resize max /mnt
umount /mnt
df -h

