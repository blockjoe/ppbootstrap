#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
	exec sudo bash "$0" "$@"
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

_LKV=`cat ../kernel-builds/LATEST`
kdir="../kernel-builds/$_LKV/pp-$_LKV"

_KBOOT="$kdir/linux.config"
_KLIB="$kdir/modules/lib"
_KUSR="$kdir/headers/include"

for ddir in m/*; do
	if [ -f "$ddir" ]; then
		continue
	fi
	cp -r "$_KLIB/." "$ddir/lib"
	cp -r "$_KUSR/." "$ddir/usr"
	if [ -d "$ddir/boot" ]; then
		cp "$_KBOOT" "$ddir/boot/"
	fi
done

