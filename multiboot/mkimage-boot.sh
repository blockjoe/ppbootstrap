#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
	exec sudo sh "$0" "$@"
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

# loglevel=15
serial="console=ttyS0,115200 earlycon=ns16550a,mmio32,0x01c28000"
silent="quiet loglevel=0 systemd.show_status=false"
bootargs_base="$serial $silent cma=256M console=tty1 consoleblank=0 panic=3 rw rootwait root=PARTUUID=12345678-02 rootfstype=btrfs rootflags=compress-force=zstd,nodatacow,subvol"

_LKV=`cat ../kernel-builds/LATEST`
kdir="../kernel-builds/$_LKV/pp-$_LKV"

(
	echo "device_id = Base Distros"
	no=0
	for ddir in ../distros/*; do
		if [ -f "$ddir" ]; then
			continue
		fi
		dist=$(basename "$ddir")

		(
			source $ddir/config
			
			echo "no = $no"
			echo "  name = $name $version"
			echo "  atf = ../p-boot/fw.bin"
			echo "  dtb = $kdir/board-1.1.dtb"
			echo "  dtb2 = $kdir/board-1.2.dtb"
			echo "  linux = $kdir/Image"
			echo "  bootargs = $bootargs_base=$dist $bootargs"
			echo "  splash = $ddir/splash.argb"
		)

		no=$(($no+1))
	done
) > boot.conf

set -e -x

L=`losetup -P --show -f multi.img`
../p-boot/p-boot-conf-native . ${L}p1
../p-boot/p-boot-conf-native . boot-part.img
losetup -d $L

dd if=../p-boot/p-boot.bin of=multi.img bs=1024 seek=8 conv=notrunc
