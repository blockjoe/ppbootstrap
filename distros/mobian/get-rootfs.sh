#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
	exec sudo bash "$0" "$@"
fi

_bs="$(dirname "${BASH_SOURCE[0]}")"
_sd="$(readlink -f "$_bs")"
_mr_dir=/home/joe/Pinephone/src/mobian-recipes

cd "$_mr_dir"

./build.sh

cd "$_sd"

if [ -f rootfs.tar.gz ]; then
	rm -rf rootfs.tar.gz
fi

if [ -f rootfs.tar.zst ]; then
	rm -rf rootfs.tar.zst
fi

if [ -f rootfs.tar ]; then
	rm -rf rootfs.tar
fi

cp "$_mr_dir"/rootfs-pinephone-phosh.tar.gz rootfs.tar.gz

gunzip rootfs.tar.gz
zstd rootfs.tar && rm -rf rootfs.tar

_ver=$(date +"%Y-%m-%d")
cat << EOF > config
version=$_ver
name="Mobian"
bootargs="splash"
EOF

