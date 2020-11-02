#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
	exec sudo bash "$0" "$@"
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

L=`losetup -P --show -f multi.img`
mount -o compress-force=zstd ${L}p2 m
