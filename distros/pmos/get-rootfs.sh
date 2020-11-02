#!/bin/bash

function cleanup {
	pmbootstrap shutdown
}
trap cleanup EXIT

cd "$(dirname "${BASH_SOURCE[0]}")"

pmbootstrap pull && 

pmbootstrap install &&

pmbootstrap export &&

./extract.sh /tmp/postmarketOS-export/pine64-pinephone.img &&

_ver=$(date +"%Y-%m-%d")
cat << EOF > config
version=$_ver
name="postmarketOS"
bootargs="init=/sbin/init PMOS_NO_OUTPUT_REDIRECT"
EOF

