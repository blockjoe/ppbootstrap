It looks like the following is the process for fedora.

1) Download the .raw image.

2) Mount the .raw image on loopback, and the third partition is the rootfs.

3) Pull that out and strip out the contents of the /boot directory, and then go ahead and tar it then zstd it.
