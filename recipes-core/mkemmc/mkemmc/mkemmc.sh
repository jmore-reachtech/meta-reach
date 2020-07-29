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

# if the eMMC is being reflashed, there are likely VFAT/EXT4 partitions automounted
# under /run/media... the kernel does not like it if the partition sizes change
# so we zero eMMC and force a reboot

EMMC_PART_BASE=/run/media/mmcblk3
EMMC_PART_FOUND="false"

for part_num in 1 2 3 4
do
	PART_DEV=${EMMC_PART_BASE}p${part_num}
	printf "\nchecking for eMMC partition at \"%s\"\n" "${PART_DEV}"
	if [ -e "${PART_DEV}" ]; then
		EMMC_PART_FOUND="true"
		umount -f ${PART_DEV} > /dev/null 2>&1
	fi
done

if [ "${EMMC_PART_FOUND}" != "false" ]; then
	printf "\nfound existing eMMC partitions...\nzeroing out eMMC\n"
	dd if=/dev/zero of=${EMMC_DEV} bs=8M count=932 conv=fdatasync status=progress
	sync
	sync
	printf "\nrebooting...\nrerun mkemmc.sh after the reboot\n\n"
	reboot
	exit 0
fi

# write 4 emmc paritions
#	p1 - VFAT - /uboot
#	p2 - EXT4 - rootfs A
#	p3 - EXT4 - rootfs B
#	p4 - EXT4 - /data
printf "\nflashing eMMC SD image \"%s\" to \"%s\"\n" "${EMMC_SDIMG}" "${EMMC_DEV}"
dd if="${EMMC_SDIMG}" of="${EMMC_DEV}" bs=8M conv=fdatasync status=progress

# write u-boot image (after clearing read only flag for boot0 partition
echo 0 > "${EMMC_RO_FLAG}"
dd if="${UBOOT_IMG}" of="${EMMC_DEV}boot0" bs=512 seek=2
echo 1 > "${EMMC_RO_FLAG}"

# set emmc to boot from boot0 partition and configure emmc hardware to reflect our connection config
printf "\nsetting up eMMC boot\n"
mmc bootpart enable 1 1 "${EMMC_DEV}"
mmc bootbus set single_backward x1 x4 "${EMMC_DEV}"

sync
sync

printf "\nThe image has been flashed to eMMC.\nInsert the boot jumper, then reboot.\n\n"
