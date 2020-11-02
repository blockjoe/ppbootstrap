#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

for ddir in ./*; do
	if [ -d "$ddir" ]; then
		if [ -f "$ddir/get-rootfs.sh" ]; then
			echo "Begin getting the rootfs for ${ddir##*/}"
			echo "---------------------------------------------"
			"${ddir}/get-rootfs.sh"
			echo "---------------------------------------------"
			echo
		fi
	fi
done
