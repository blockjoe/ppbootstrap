#!/bin/sh

if [ "$(whoami)" != "root" ] ; then
	exec sudo sh "$0" "$@"
fi

L=`losetup -P --show -f "$1"`

mkdir -p m
mount ${L}p2 m
mount ${L}p1 m/boot
tar -cvf - -C m --numeric-owner . | zstd -z -4 - > rootfs.tar.zst
umount m/boot
umount m

losetup -d $L
