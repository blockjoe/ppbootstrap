#!/bin/bash

_tarball="ArchLinuxARM-aarch64-latest.tar.gz"

function cleanup {
	if [ -f "$_tarball" ]; then
		rm "$_tarball"
	fi
}
trap cleanup EXIT

cd "$(dirname "${BASH_SOURCE[0]}")"

cleanup

wget "http://os.archlinuxarm.org/os/${_tarball}" &&
zcat "$_tarball" | zstd -z - > rootfs.tar.zst &&

_ver=$(date +"%Y-%m-%d")
cat << EOF > config
version=$_ver
name="Arch Linux ARM"
bootargs=
EOF

