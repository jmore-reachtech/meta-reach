#!/bin/bash

VERSION=1.0
SCRIPT_TIME_STAMP=$(date +%Y%d%m%H%m)

if [ $# -lt 1 ]; then
	echo "Usage: $0 <machine number>"
	exit 1
fi

MACHINE="$1"

BASE_DIR="tmp/deploy/images/g2h-solo-${MACHINE}/"

if [ ! -d ${BASE_DIR} ]; then
	echo "Base dir '${BASE_DIR}' Not Found!"
	exit 1
fi

echo "Base dir:  ${BASE_DIR}"

BOOTIMAGE=${BASE_DIR}/boot.img
SDCARD="g2h-${MACHINE}-CUST.img"
if [ -f ${SDCARD} ]; then
	echo "Found SD card image, removing"
	rm $SDCARD
fi

PART1_SIZE=$(expr 1024 \* 1024 \* 10)
PART2_SIZE=$(expr 1024 \* 1024 \* 768)
PART3_SIZE=$(expr 1024 \* 1024 \* 768)
PART4_SIZE=$(expr 1024 \* 1024 \* 768)

# SD card layout
PART1_START=$(expr 1024 \* 1024)
PART1_END=$(expr ${PART1_START} \+ ${PART1_SIZE} \- 512)

PART2_START=$(expr ${PART1_END} \+ 512)
PART2_END=$(expr ${PART2_START} \+ ${PART2_SIZE} \- 512)

PART3_START=$(expr ${PART2_END} \+ 512)
PART3_END=$(expr ${PART3_START} \+ ${PART3_SIZE} \- 512)

PART4_START=$(expr ${PART3_END} \+ 512)
PART4_END=$(expr ${PART4_START} \+ ${PART4_SIZE} \- 512)

# Create image file
dd if=/dev/zero of=${SDCARD} bs=1M count=2560

# Create partition table
parted -s ${SDCARD} mklabel msdos
parted -s ${SDCARD} unit B mkpart primary fat32 ${PART1_START} ${PART1_END}
parted -s ${SDCARD} unit B mkpart primary ${PART2_START} ${PART2_END}
parted -s ${SDCARD} unit B mkpart primary ${PART3_START} ${PART3_END}
parted -s ${SDCARD} unit B mkpart primary ${PART4_START} ${PART4_END}

# Flash install bins
MTD_0=${BASE_DIR}/reach-image-qt5-g2h-solo-${MACHINE}.ubifs
MTD_1=${BASE_DIR}/reach-image-qt5.app.ubifs
MTD_2=${BASE_DIR}/u-boot-nor.imx
MTD_3=${BASE_DIR}/u-boot-env-nor.bin
MTD_4=${BASE_DIR}/zImage-imx6dl-g2h-${MACHINE}.dtb
MTD_5=${BASE_DIR}/zImage

# create tmp for for factory partition
MFG_TEMP_DIR="/tmp/$RANDOM"
mkdir $MFG_TEMP_DIR

# copy bins to factory partition
cp $MTD_0 $MFG_TEMP_DIR/mtd.0.ubifs.rootfs0
cp $MTD_1 $MFG_TEMP_DIR/mtd.1.ubifs.apps0
cp $MTD_2 $MFG_TEMP_DIR/mtd.2.imx
cp $MTD_3 $MFG_TEMP_DIR/mtd.3.bin
cp $MTD_4 $MFG_TEMP_DIR/mtd.4.bin
cp $MTD_5 $MFG_TEMP_DIR/mtd.5.bin

# generate the fs
genext2fs -b $(expr 512 \* 1024) -d ${MFG_TEMP_DIR} -i 8192 ${BASE_DIR}/g2h-solo-${MACHINE}-${SCRIPT_TIME_STAMP}.mfg.ext3
tune2fs -j ${BASE_DIR}/g2h-solo-${MACHINE}-${SCRIPT_TIME_STAMP}.mfg.ext3

# create symlink
pushd ${BASE_DIR} && ln -sf g2h-solo-${MACHINE}-${SCRIPT_TIME_STAMP}.mfg.ext3 g2h-solo-${MACHINE}.mfg.ext3 && popd

# clean up
rm -rf $MFG_TEMP_DIR

# Write bootload and env
dd if=${BASE_DIR}/u-boot-g2h-solo-${MACHINE}.imx of=${SDCARD} conv=notrunc seek=2 bs=512
dd if=${BASE_DIR}/u-boot-env.bin of=${SDCARD} bs=512 seek=768 conv=notrunc

BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDCARD} unit b print \
	                  | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 1024 }')

# Generate FAT filesystem and write kernel
mkfs.vfat -n "boot" -S 512 -C ${BOOTIMAGE} $BOOT_BLOCKS
mcopy -i ${BOOTIMAGE} -s ${BASE_DIR}/zImage  ::/zImage
mcopy -i ${BOOTIMAGE} -s ${BASE_DIR}/zImage-imx6dl-g2h-${MACHINE}.dtb  ::/imx6dl-g2h-${MACHINE}.dtb

dd if=${BOOTIMAGE} of=${SDCARD} conv=notrunc seek=1 bs=$(expr ${PART1_START})

# Delete our FAT image
rm ${BOOTIMAGE}

# Write the rootfs
dd if=${BASE_DIR}/reach-image-qt5-g2h-solo-${MACHINE}.ext3 of=${SDCARD} \
	conv=notrunc seek=1 bs=$(expr ${PART2_START})

# Write the appfs
dd if=${BASE_DIR}/reach-image-qt5.app.ext3 of=${SDCARD} \
	conv=notrunc seek=1 bs=$(expr ${PART3_START})

# Write the factoryfs
dd if=${BASE_DIR}/g2h-solo-${MACHINE}.mfg.ext3 of=${SDCARD} \
	conv=notrunc seek=1 bs=$(expr ${PART4_START})

sync && sync

#tmp/deploy/images/g2h-solo-1/u-boot-g2h-solo-1.imx
#tmp/deploy/images/g2h-solo-1/u-boot-env.bin
#tmp/deploy/images/g2h-solo-1/reach-image-qt5-g2h-solo-1.ext3 - need symlink
#tmp/deploy/images/g2h-solo-1/reach-image-qt5-g2h-solo-1.app.ext3
#tmp/deploy/images/g2h-solo-1/reach-image-qt5-g2h-solo-1.ubifs
#tmp/deploy/images/g2h-solo-1/reach-image-qt5.app.ubifs
#tmp/deploy/images/g2h-solo-1/u-boot-nor.imx
#tmp/deploy/images/g2h-solo-1/u-boot-env-nor.bin
#tmp/deploy/images/g2h-solo-1/zImage
#tmp/deploy/images/g2h-solo-1/zImage-imx6dl-g2h-1.dtb


