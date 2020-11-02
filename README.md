# ppbootstrap

My helper scripts for bootstrapping together as much of a working Pinephone enviornment as possible.

## Explanation/Usage

distros
  - update-distros.sh: run the get-rootfs.sh script in the subdirectory representing the distro
  {{ distro }}
    - get-rootfs.sh: aquire the latest rootfs, tar.zst it, and store it in this directory.


kernel-builds
  - get-latest.sh: download the latest uploaded kernel build
  - LATEST: the latest build version

local-config: any variables to source into the scope (right now SDCARD)

p-boot: all ripped from p-boot repo
  - fw.bin
  - p-boot.bin
  - p-boot-conf-native

splashes: .argbs ripped from pinephone-mutliboot

multiboot:
  - mkimage.sh: Create multi.img from the rootfs.tar.zst files in the distro directories
  - mkimage-boot.sh: Ran during mkimage.sh to configure p-boot
  - mkimage-apply-fixes.sh: Ran during mkimage.sh to patch anything in the overrides directory of the distro
  - add-modules-and-headers.sh: Move the modules and headers from the latest kernel build into the root directory
  - mount.sh: mounts multi.img on loopback
  - umount.sh: unmounts multi.img
  - to-microsd.sh: dds mutli.img to the microsd card specified
  - expand-to-fill.sh: expands the filesystem of multi.img to fit the whole sd card
  - build-latest-image.sh: all of that
  dedup: scripts from the original pinephone-multiboot to dedup the filesystem to shrink it
  files: copy of splashes (could probably symlink) required for some reason.
  multi.img: the multiboot image of all the distros in distros

## TODO:

### Setup

#### ppbootstrap

Need at least a .conf file (could migrate local-config to do this) to specify the following.

`$SDCARD`: The device that specifies the sd card to write the image to.
`$DEP_DIR`: The paths to any dependency commands (debos, pmbootstrap etc).
`$DISTROS`: Which distros to use (currently uses everything in distros directory).
`$USERNAME`: Optional default username for all distros
`$PASSWORD`: Optional default password for all distros
`$WPA_SUPPLICANT`: Optional default WPA supplicant for all distros

#### p-boot

Need to clone the p-boot directory and build a p-boot-conf-native

#### Distros

Each distro should have a setup.sh script for configuring the environments needed there,
as well as a setup.conf to easily access anything that should change.

##### pmos

- Make sure pmbootstrap is installed/install pmbootstrap
- Handle pmbootstrap init (through expect)

##### mobian

- Make sure debos is installed/install debos
- Take care of the mobian-recipe here

### Packaging

It would be nice to add in some better packaging configurations that can occuring after getting, or during building this initial rootfs.

[rice]
neofetch

[dev]
vim
git
xephyr

[core]
lightdm
xserver-xorg
phosh

[dock-desk-xfce]
xfce4

[dock-desk-mate]
mate

