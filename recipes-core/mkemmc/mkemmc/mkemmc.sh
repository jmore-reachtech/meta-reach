#!/bin/sh

if [ -z "$1" ]; then
	echo ""
	echo "Usage: $0 <path_to_u-boot_image> <path_to_emmc_sdimg>"
	exit 1;
fi

# path to emmc u-boot
UBOOT_IMG=$1

# path to emmc sdimg
EMMC_SDIMG=$2
 
# partition size in MB
BOOT_ROM_SIZE=10

# emmc device
EMMC_DEV=/dev/mmcblk3
EMMC_RO_FLAG=/sys/block/mmcblk3boot0/force_ro

# wait for the emmc device node ready
while [ ! -e ${EMMC_DEV} ]
do
	sleep 1
	echo "waiting for ${EMMC_DEV} to appear"
done

# destroy the partition table
dd if=/dev/zero of=${EMMC_DEV} bs=1024 count=1

# call sfdisk to create new partition table
sfdisk --force ${EMMC_DEV} << EOF
${BOOT_ROM_SIZE}M,500M,0c
600M,,83
EOF

# write 4 emmc paritions
dd if=${EMMC_SDIMG} of=${EMMC_DEV}

# write u-boot image (after clearing read only flag for boot0 partition
echo 0 > ${EMMC_RO_FLAG}
dd if=${UBOOT_IMG} of=${EMMC_DEV}boot0 bs=512 seek=2
echo 1 > ${EMMC_RO_FLAG}

# set emmc to boot from boot0 partition and configure emmc hardware to reflect our connection config
mmc bootpart enable 1 1 ${EMMC_DEV}
mmc bootbus set single_backward x1 x4 ${EMMC_DEV}

