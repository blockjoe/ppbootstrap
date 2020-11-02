#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
	exec sudo bash "$0" "$@"
fi

PASS='$6$nzZZGV65imLStmVz$u/Z1litGJh5tV2NmvzeirBiPkwWmhD0CQ.xRzdOV26vMxURbQUDW8Nkss8mvYVzwQ5SnwvGV/.ttSG0Kmrg.L/'

#mkdir -p m/ut/android/{cache,data,factory,firmware,odm,persist,system{,/vendor}}
#touch m/ut/userdata/.writable_image

for ddir in ../distros/*
do
	if [ -f "$ddir" ]; then
		continue
	fi
	name=$(basename "$ddir")
	mdir=m/$name

	(
		cd $mdir || exit
		ddir="../../$ddir"

		sed -i '/mmcblk\|UUID/d' etc/fstab
		sed -i "s#\$6\$.*#$PASS:::::::#" etc/shadow
		sed -i "s#^root:.*#root:$PASS:::::::#" etc/shadow

		mkdir -p etc/systemd/journald.conf.d
		cat <<EOF > etc/systemd/journald.conf.d/xnux.conf
[Journal]
Storage=none
EOF

		while IFS= read -r -d $'\0' src
		do
			dst="${src#$ddir/overrides/}"
			chattr -i "$dst"
			test -f ".xnux.eu/orig/$dst" || {
				mkdir -p "$(dirname ".xnux.eu/orig/$dst")"
				cp "$dst" ".xnux.eu/orig/$dst"
			}
			cat "$src" > "$dst"
			chattr +i "$dst"
		done < <(find "$ddir/overrides" -type f -print0)		
	)

	test -f $mdir.orig || btrfs subvolume snapshot $mdir $mdir.orig
done
