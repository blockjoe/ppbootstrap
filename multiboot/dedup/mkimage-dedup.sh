#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
	exec sudo bash "$0" "$@"
fi

set -e -x

# make sure image fits on a typical 8GB SD card

rm -f multi.img
truncate -s 7000M multi.img

sfdisk -W always multi.img <<EOF
label: dos
label-id: 0x12345678
unit: sectors
sector-size: 512

4M,124M,L,*
128M,,L
EOF

L=`losetup -P --show -f multi.img`

mkfs.btrfs ${L}p2

mkdir -p m
mount -o compress-force=zstd ${L}p2 m

for ddir in distros/*
do
	name=${ddir#distros/}
	btrfs subvolume create m/$name
	specs="$specs m/$name:$ddir/rootfs.tar.zst"
done

./tools/extract $specs

./mkimage-apply-fixes.sh

umount m
losetup -d "$L"

./mkimage-boot.sh
