#! /bin/bash
# (c) Copyright 2013 Jeff Horn <jhorn@reachtech.com>
# Licensed under terms of GPLv2
#

VERSION=1.0
SCRIPT_TIME_STAMP=$(date +%Y%d%m%H%m)

show_usage() {
	echo "usage: mk_mfg.sh <machine> <image for SD card> <image for NAND>"
	echo ""
	echo "By default the script uses the base Yocto images directory at "
	echo "BUILD_DIR/tmp/deploy/images.  You can set the environment "
	echo "variable IMAGE_DIR to override the image location"
	echo ""
}

MACHINE="$1"
if [ -z "$MACHINE" ]; then
	echo "must set the machine"
	show_usage
	exit 1
fi

SD_IMAGE="$2"
if [ -z "$SD_IMAGE" ]; then
	echo "must set the SD card image"
	show_usage
	exit 1
fi

FLASH_IMAGE="$3"
if [ -z "$FLASH_IMAGE" ]; then
	echo "must set the NAND image"
	show_usage
	exit 1
fi


echo "Machine: $MACHINE"
echo "SD Image: $SD_IMAGE"
echo "Flash Image: $FLASH_IMAGE"


CUR_WD=$(pwd)
WORK_DIR=$CUR_WD
if [ -z "$IMAGE_DIR" ]; then
	echo "IMAGE_DIR not set, using default"
	IMAGE_DIR="$CUR_WD/tmp/deploy/images/$MACHINE"
else
	echo "IMAGE_DIR set, using env"
fi

ROOTFS_SIZE=$(expr 512 \* 1024)
MFGFS_SIZE=$(expr 512 \* 1024)

# Boot partition size [in KiB]
BOOT_SPACE="8192"

# Set alignment to 4MB [in KiB]
IMAGE_ROOTFS_ALIGNMENT="4096"

# Align boot partition and calculate total SD card image size
BOOT_SPACE_ALIGNED=$(expr $BOOT_SPACE + $IMAGE_ROOTFS_ALIGNMENT - 1)
BOOT_SPACE_ALIGNED=$(expr $BOOT_SPACE_ALIGNED - $BOOT_SPACE_ALIGNED % $IMAGE_ROOTFS_ALIGNMENT)
SDCARD_SIZE=$(expr $IMAGE_ROOTFS_ALIGNMENT + $BOOT_SPACE_ALIGNED + $ROOTFS_SIZE + $IMAGE_ROOTFS_ALIGNMENT + $MFGFS_SIZE + $IMAGE_ROOTFS_ALIGNMENT)


if [ ! -e $IMAGE_DIR ]; then
    echo "This tool must be run from your Yocto build directory"
    exit 1;
fi

# add the yocto host tools path
export PATH=$CUR_WD/tmp/sysroots/i686-linux/usr/bin:$PATH

SDCARD="$MACHINE-mfg.sdcard"
if [ -f $SDCARD ]; then
	echo "Found SD card image, removing"
	rm $SDCARD
fi

# this sets the image for the SD card
SD_ROOTFS_IMAGE=$IMAGE_DIR/$SD_IMAGE-$MACHINE.ext3
if [ ! -f $SD_ROOTFS_IMAGE ]; then
	echo "SD_ROOTFS_IMAGE $ROOTFS_IMAGE not found"
	exit 1
fi

SD_ROOTFS_UBIFS=$IMAGE_DIR/$SD_IMAGE-$MACHINE.ubifs
if [ ! -f $SD_ROOTFS_UBIFSE ]; then
	echo "SD_ROOTFS_UBIFS $ROOTFS_UBIFS not found"
	exit 1
fi

SD_BOOT_IMAGE=$IMAGE_DIR/$SD_IMAGE-$MACHINE.linux.sb
if [ ! -f $SD_BOOT_IMAGE ]; then
	echo "SD_BOOT_IMAGE $BOOT_IMAGE not found"
	exit 1
fi

SD_BOOT_IMAGE_HEADER=$IMAGE_DIR/$SD_IMAGE-$MACHINE.sb.header
if [ ! -f $SD_BOOT_IMAGE_HEADER ]; then
	echo "SD_BOOT_IMAGE_HEADER $BOOT_IMAGE_HEADER not found"
	exit 1
fi

# this sets the image for the flash
FLASH_ROOTFS_IMAGE=$IMAGE_DIR/$FLASH_IMAGE-$MACHINE.ext3
if [ ! -f $FLASH_ROOTFS_IMAGE ]; then
	echo "FLASH_ROOTFS_IMAGE $ROOTFS_IMAGE not found"
	exit 1
fi

FLASH_ROOTFS_UBIFS=$IMAGE_DIR/$FLASH_IMAGE-$MACHINE.ubifs
if [ ! -f $FLASH_ROOTFS_UBIFSE ]; then
	echo "FLASH_ROOTFS_UBIFS $ROOTFS_UBIFS not found"
	exit 1
fi

FLASH_BOOT_IMAGE=$IMAGE_DIR/$FLASH_IMAGE-$MACHINE.linux.sb
if [ ! -f $FLASH_BOOT_IMAGE ]; then
	echo "FLASH_BOOT_IMAGE $BOOT_IMAGE not found"
	exit 1
fi

FLASH_BOOT_IMAGE_HEADER=$IMAGE_DIR/$FLASH_IMAGE-$MACHINE.sb.header
if [ ! -f $FLASH_BOOT_IMAGE_HEADER ]; then
	echo "FLASH_BOOT_IMAGE_HEADER $BOOT_IMAGE_HEADER not found"
	exit 1
fi

# Initialize a sparse file
dd if=/dev/zero of=${SDCARD} bs=1 count=0 seek=$(expr 1024 \* ${SDCARD_SIZE})

# Create partition table
parted -s ${SDCARD} mklabel msdos

PART1_START=1024
PART1_SIZE=$(expr $IMAGE_ROOTFS_ALIGNMENT \+ $BOOT_SPACE_ALIGNED)
PART2_START=$(expr $IMAGE_ROOTFS_ALIGNMENT \+ $BOOT_SPACE_ALIGNED)
PART2_SIZE=$(expr $IMAGE_ROOTFS_ALIGNMENT \+ $BOOT_SPACE_ALIGNED \+ $ROOTFS_SIZE)
PART3_START=$(expr $IMAGE_ROOTFS_ALIGNMENT \+ $BOOT_SPACE_ALIGNED \+ $ROOTFS_SIZE)
PART3_SIZE=$(expr $IMAGE_ROOTFS_ALIGNMENT \+ $BOOT_SPACE_ALIGNED \+ $ROOTFS_SIZE \+ $IMAGE_ROOTFS_ALIGNMENT \+ $MFGFS_SIZE)

# partition the device
parted -s $SDCARD unit KiB mkpart primary $PART1_START $PART1_SIZE
parted -s $SDCARD unit KiB mkpart primary $PART2_START $PART2_SIZE
parted -s $SDCARD unit KiB mkpart primary $PART3_START $PART3_SIZE

# write the bootstream HAB header
dd if=$SD_BOOT_IMAGE_HEADER of=$SDCARD conv=notrunc seek=2048

# write the bootstream
dd if=$SD_BOOT_IMAGE of=$SDCARD conv=notrunc seek=2049

# write the rootfs
dd if=$SD_ROOTFS_IMAGE of=$SDCARD conv=notrunc seek=1 bs=$(expr $BOOT_SPACE_ALIGNED \* 1024 + $IMAGE_ROOTFS_ALIGNMENT \* 1024) && sync && sync

# create directory for ubifs and bootstream images for mfg
MFG_TEMP_DIR="/tmp/$RANDOM"
mkdir $MFG_TEMP_DIR

# the mtd.N.TYPE is used by the flash installer
cp $FLASH_BOOT_IMAGE $MFG_TEMP_DIR/mtd.0.sb
cp $FLASH_ROOTFS_UBIFS $MFG_TEMP_DIR/mtd.1.ubifs

genext2fs -b $MFGFS_SIZE -d $MFG_TEMP_DIR -i 8192 $IMAGE_DIR/$MACHINE-$SCRIPT_TIME_STAMP.mfg.ext3
tune2fs -j $IMAGE_DIR/$MACHINE-$SCRIPT_TIME_STAMP.mfg.ext3

# remove the symlink
rm $IMAGE_DIR/$MACHINE.mfg.ext3
ln -s $IMAGE_DIR/$MACHINE-$SCRIPT_TIME_STAMP.mfg.ext3 $IMAGE_DIR/$MACHINE.mfg.ext3

# clean up
rm -rf $MFG_TEMP_DIR

# write the mfgfs
dd if=$IMAGE_DIR/$MACHINE.mfg.ext3 of=$SDCARD conv=notrunc seek=1 bs=$(expr $BOOT_SPACE_ALIGNED \* 1024 + $IMAGE_ROOTFS_ALIGNMENT \* 1024 + $ROOTFS_SIZE \* 1024) && sync && sync

# Setting partition type to 0x53 as required for mxs' SoC family
echo -n S | dd of=${SDCARD} bs=1 count=1 seek=450 conv=notrunc

parted ${SDCARD} print

echo "SD card creation was successful"

exit 0;
