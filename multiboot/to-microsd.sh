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

umount "$SDCARD_P2"

dd if=multi.img of="$SDCARD" bs=8M status=progress
sync

./expand-to-fill.sh
