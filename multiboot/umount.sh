#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
	exec sudo bash "$0" "$@"
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

umount m
losetup -d $(losetup -l | grep multi.img | cut -d ' ' -f 1)
