#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ -f ../kernel-builds/get-latest.sh ]; then
	echo "Getting the latest kernel builds"
	echo "--------------------------------"
	echo
	../kernel-builds/get-latest.sh
	echo "--------------------------------"
	echo
fi

if [ -f ../distros/update-distros.sh ]; then
	echo "Updating the distros"
	echo "-----------------------"
	echo
	../distros/update-distros.sh
	echo "-----------------------"
	echo
	echo "Writing the image"
	echo "-----------------------"
	./mkimage.sh
	_img_loc="$(readlink -f ./multi.img)"
	echo
	echo "Image written at: ${_img_loc}"
fi

