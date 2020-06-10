#!/bin/sh

if [ -z "$1" -o -z "$2" ]; then
	printf "\nUsage: %s <path_to_u-boot_image> <path_to_emmc_sdimg>\n\n" "$0"
	exit 1
fi

# path to emmc u-boot
UBOOT_IMG="$1"

if [ ! -e "${UBOOT_IMG}" ]; then
	printf "\nU-boot image \"%s\" not found\n\n" "${UBOOT_IMG}"
	exit 1
fi

# path to emmc sdimg
EMMC_SDIMG="$2"

if [ ! -e "${EMMC_SDIMG}" ]; then
	printf "\neMMC SD image \"%s\" not found\n\n" "${EMMC_SDIMG}"
	exit 1
fi
 
# emmc device
EMMC_DEV=/dev/mmcblk3
EMMC_RO_FLAG=/sys/block/mmcblk3boot0/force_ro

# wait for the emmc device node ready
while [ ! -e "${EMMC_DEV}" ]
do
	sleep 1
	printf "waiting for \"%s\" to appear...\n" "${EMMC_DEV}"
done

# the eMMC comes from the factory with a single VFAT partition which will be automounted
# make sure it's not mounted, otherwise the kernel will not see the updated partition
# table after the image is falshed to the eMMC

EMMC_PART1=/run/media/mmcblk3p1

if [ -e "${EMMC_PART1}" ]; then
	printf "\nunmounting eMMC default VFAT partition at \"%s\"\n" "${EMMC_PART1}"
	umount "${EMMC_PART1}"
fi
 
# write 4 emmc paritions
#	p1 - VFAT - /uboot
#	p2 - EXT4 - rootfs A
#	p3 - EXT4 - rootfs B
#	p4 - EXT4 - /data
printf "\nflashing eMMC SD image \"%s\" to \"%s\"\n" "${EMMC_SDIMG}" "${EMMC_DEV}"
dd if="${EMMC_SDIMG}" of="${EMMC_DEV}"

# write u-boot image (after clearing read only flag for boot0 partition
echo 0 > "${EMMC_RO_FLAG}"
dd if="${UBOOT_IMG}" of="${EMMC_DEV}boot0" bs=512 seek=2
echo 1 > "${EMMC_RO_FLAG}"

# set emmc to boot from boot0 partition and configure emmc hardware to reflect our connection config
printf "\nsetting up eMMC boot\n"
mmc bootpart enable 1 1 "${EMMC_DEV}"
mmc bootbus set single_backward x1 x4 "${EMMC_DEV}"

# expand p4 to use the rest of eMMC
EMMC_PART4="${EMMC_DEV}p4"

printf "\nexpanding eMMC partition 4 (/data)\n"
parted "${EMMC_DEV}" << EOF
print
resizepart 4
-1s
print
EOF

# we have to reboot to see the new partitions... partprobe can't update the kernel
# even though nothing is mounted from eMMC because something in the kernel is
# holding a reference to at least one eMMC resource

# this is similar to how Raspian expands its rootfs on first boot

printf "\nsetting up resize of EXT4 filesystem in \"%s\" at next reboot\n" "${EMMC_PART4}"
touch /.resize_emmc_part4

printf "\nThe system must reboot to use the new eMMC partitions.\n\n"

printf "Rebooting in 5 seconds.. press ^C to cancel\n\n"

sleep 5

sync
sync
reboot
