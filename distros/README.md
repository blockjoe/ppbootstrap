This is where all of the files for each distro to be placed on the image currently live.

Each distro needs a splash.argb, get-rootfs.sh script, and a rootfs.tar.zst.

Anything in the overrides directory will be copied in place overtop of the file specified starting from / of the rootfs of that distro.
