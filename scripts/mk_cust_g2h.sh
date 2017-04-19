#!/bin/bash

VERSION=1.0
SCRIPT_TIME_STAMP=$(date +%Y%d%m%H%m)

if [ $# -lt 1 ]; then
	echo "Usage: $0 <machine number>"
	exit 1
fi

MACHINE="$1"

BASE_DIR="tmp/deploy/images/g2h-solo-${MACHINE}"

if [ ! -d ${BASE_DIR} ]; then
	echo "Base dir '${BASE_DIR}' Not Found!"
	exit 1
fi

echo "Base dir:  ${BASE_DIR}"

BOOTIMAGE=${BASE_DIR}/boot.img
SDCARD="g2h-${MACHINE}-CUST.img"
if [ -f ${SDCARD} ]; then
	echo "Found SD card image, removing"
	rm ${SDCARD}
	sync && sync
fi

# boot partition
PART1_SIZE=$(expr 1024 \* 1024 \* 10)
# rootfs partition
PART2_SIZE=$(expr 1024 \* 1024 \* 768)
# factory partition
PART3_SIZE=$(expr 1024 \* 1024 \* 768)

# SD card layout
PART1_START=$(expr 1024 \* 1024 \* 5)
PART1_END=$(expr ${PART1_START} \+ ${PART1_SIZE} \- 512)

PART2_START=$(expr ${PART1_END} \+ 512)
PART2_END=$(expr ${PART2_START} \+ ${PART2_SIZE} \- 512)

PART3_START=$(expr ${PART2_END} \+ 512)
PART3_END=$(expr ${PART3_START} \+ ${PART3_SIZE} \- 512)


# Flash install bins
if [ "${MACHINE}" == "11f-r" ]; then
	MTD_0=${BASE_DIR}/zImage-imx6dl-g2h-11f.dtb
elif [ "${MACHINE}" == "3-r" ]; then
	MTD_0=${BASE_DIR}/zImage-imx6dl-g2h-3.dtb
else
	MTD_0=${BASE_DIR}/zImage-imx6dl-g2h-${MACHINE}.dtb
fi
MTD_1=${BASE_DIR}/zImage
MTD_2=${BASE_DIR}/reach-image-qt5-g2h-solo-${MACHINE}.ubifs
MTD_3=${BASE_DIR}/u-boot-nor.imx
MTD_4=${BASE_DIR}/u-boot-env-nor.bin

# Make all the files exist
if [ ! -f ${MTD_0} ]; then
    echo "Cannot find ${MTD_0}"
    exit 1
fi
if [ ! -f ${MTD_1} ]; then
    echo "Cannot find ${MTD_1}"
    exit 1
fi
if [ ! -f ${MTD_2} ]; then
    echo "Cannot find ${MTD_2}"
    exit 1
fi
if [ ! -f ${MTD_3} ]; then
    echo "Cannot find ${MTD_3}"
    exit 1
fi
if [ ! -f ${MTD_4} ]; then
    echo "Cannot find ${MTD_4}"
    exit 1
fi

# Create image file
dd if=/dev/zero of=${SDCARD} bs=1M count=2048

# Create partition table
parted -s ${SDCARD} mklabel msdos
parted -s ${SDCARD} unit B mkpart primary fat32 ${PART1_START} ${PART1_END}
parted -s ${SDCARD} unit B mkpart primary ${PART2_START} ${PART2_END}
parted -s ${SDCARD} unit B mkpart primary ${PART3_START} ${PART3_END}

# create tmp for for factory partition
MFG_TEMP_DIR="/tmp/$RANDOM"
mkdir $MFG_TEMP_DIR

# copy bins to factory partition
cp -L $MTD_0 $MFG_TEMP_DIR/mtd.0.nand
cp -L $MTD_1 $MFG_TEMP_DIR/mtd.1.nand
cp -L $MTD_2 $MFG_TEMP_DIR/mtd.2.ubifs.rootfs0
cp -L $MTD_3 $MFG_TEMP_DIR/mtd.3.imx
cp -L $MTD_4 $MFG_TEMP_DIR/mtd.4.bin

# generate the fs
genext2fs -b $(expr 512 \* 1024) -d ${MFG_TEMP_DIR} -i 8192 ${BASE_DIR}/g2h-solo-${MACHINE}-${SCRIPT_TIME_STAMP}.mfg.ext3
tune2fs -j ${BASE_DIR}/g2h-solo-${MACHINE}-${SCRIPT_TIME_STAMP}.mfg.ext3

# create symlink
pushd ${BASE_DIR} && ln -sf g2h-solo-${MACHINE}-${SCRIPT_TIME_STAMP}.mfg.ext3 g2h-solo-${MACHINE}.mfg.ext3 && popd

# clean up
rm -rf $MFG_TEMP_DIR

BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDCARD} unit b print \
	                  | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 1024 }')

# Generate FAT filesystem and write kernel
if [ -f "${BOOTIMAGE}" ]; then
	echo "removing BOOTIMAGE ${BOOTIMAGE}"
	rm ${BOOTIMAGE}
fi
mkfs.vfat -n "boot" -S 512 -C ${BOOTIMAGE} $BOOT_BLOCKS
mcopy -i ${BOOTIMAGE} -s ${BASE_DIR}/zImage  ::/zImage
if [ "${MACHINE}" == "11f-r" ]; then
	mcopy -i ${BOOTIMAGE} -s ${BASE_DIR}/zImage-imx6dl-g2h-11f.dtb  ::/imx6dl-g2h-11f.dtb
elif [ "${MACHINE}" == "3-r" ]; then
	mcopy -i ${BOOTIMAGE} -s ${BASE_DIR}/zImage-imx6dl-g2h-3.dtb  ::/imx6dl-g2h-3.dtb
else
	mcopy -i ${BOOTIMAGE} -s ${BASE_DIR}/zImage-imx6dl-g2h-${MACHINE}.dtb  ::/imx6dl-g2h-${MACHINE}.dtb
fi

# Write bootloader
BOOTLOADER=${BASE_DIR}/u-boot-g2h-solo-${MACHINE}.imx
echo "Writing bootloader ${BOOTLOADER}"
dd if=${BOOTLOADER} of=${SDCARD} conv=notrunc seek=2 bs=512

# Write boot env
BOOTENV=${BASE_DIR}/u-boot-env.bin
echo "Writing boot env ${BOOTENV}"
dd if=${BOOTENV} of=${SDCARD} bs=512 seek=1536 conv=notrunc

# Write kernel and device tree
echo "Writing kernel ${BOOTIMAGE}"
dd if=${BOOTIMAGE} of=${SDCARD} conv=notrunc seek=$(expr ${PART1_START} / 512) bs=512

# Write the rootfs
ROOTFS=${BASE_DIR}/reach-image-qt5-g2h-solo-${MACHINE}.ext3
echo "Writing rootfs ${ROOTFS}"
dd if=${ROOTFS} of=${SDCARD} conv=notrunc seek=$(expr ${PART2_START} / 512) bs=512

# Write the factoryfs
FACTORYFS=${BASE_DIR}/g2h-solo-${MACHINE}.mfg.ext3
echo "Writing factoryfs ${FACTORYFS}"
dd if=${FACTORYFS} of=${SDCARD} conv=notrunc seek=$(expr ${PART3_START} / 512) bs=512

sync && sync
