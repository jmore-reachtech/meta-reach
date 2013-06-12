#! /bin/bash
# (c) Copyright 2013 Jeff Horn <jhorn@reachtehc.com>
# Licensed under terms of GPLv2
#

VERSION=1.0

SCRIPT_TIME_STAMP=$(date +%Y%d%m%H%m)

MACHINE="g2c1"
DEFAULT_IMAGE="reach-image-x11"


PWD=$(pwd)
WORK_DIR=$PWD
IMAGE_DIR="$PWD/tmp/deploy/images"

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
export PATH=$PWD/tmp/sysroots/i686-linux/usr/bin:$PATH

if [ $# -eq 0 ]; then
    echo ""
    echo "$0 version $VERSION"
    echo "Usage: $0 <drive> <machine>"
    echo "   drive: SD device (i.e. /dev/sdc)"
    echo "   image: target image (default reach-image-x11)"
    exit 1;
fi

if [ "$1" = "/dev/sda" ] ; then
    echo "Sorry, /dev/sda probably holds your PC's rootfs.  Please
specify a SD device."
    exit 1;
fi
DRIVE=$1
echo "Using SD devive $DRIVE"

if [ -z "$2" ]; then
    IMAGE=$DEFAULT_IMAGE
else
    IMAGE=$2
fi
echo "Using image $IMAGE"

SDCARD="$IMAGE.mfg.sdcard"
if [ -f $SDCARD ]; then
	echo "Found SD card image, removing"
	rm $SDCARD
fi

ROOTFS_IMAGE=$IMAGE_DIR/$IMAGE-$MACHINE.ext3
if [ ! -f $ROOTFS_IMAGE ]; then
	echo "ROOTFS_IMAGE $ROOTFS_IMAGE not found"
	exit 1
fi

ROOTFS_UBIFS=$IMAGE_DIR/$IMAGE-$MACHINE.ubifs
if [ ! -f $ROOTFS_UBIFSE ]; then
	echo "ROOTFS_UBIFS $ROOTFS_UBIFS not found"
	exit 1
fi

BOOT_IMAGE=$IMAGE_DIR/$IMAGE-$MACHINE.linux.sb
if [ ! -f $BOOT_IMAGE ]; then
	echo "BOOT_IMAGE $BOOT_IMAGE not found"
	exit 1
fi

BOOT_IMAGE_HEADER=$IMAGE_DIR/$IMAGE-$MACHINE.sb.header
if [ ! -f $BOOT_IMAGE_HEADER ]; then
	echo "BOOT_IMAGE_HEADER $BOOT_IMAGE_HEADER not found"
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
dd if=$BOOT_IMAGE_HEADER of=$SDCARD conv=notrunc seek=2048

# write the bootstream
dd if=$BOOT_IMAGE of=$SDCARD conv=notrunc seek=2049

# write the rootfs
dd if=$ROOTFS_IMAGE of=$SDCARD conv=notrunc seek=1 bs=$(expr $BOOT_SPACE_ALIGNED \* 1024 + $IMAGE_ROOTFS_ALIGNMENT \* 1024) && sync && sync

# create directory for ubifs and bootstream images for mfg
MFG_TEMP_DIR="/tmp/$RANDOM"
mkdir $MFG_TEMP_DIR

# the mtd.N.TYPE is used by the flash installer
cp $BOOT_IMAGE $MFG_TEMP_DIR/mtd.0.sb
cp $ROOTFS_UBIFS $MFG_TEMP_DIR/mtd.1.ubifs

genext2fs -b $MFGFS_SIZE -d $MFG_TEMP_DIR -i 8192 $IMAGE_DIR/$IMAGE-$MACHINE-$SCRIPT_TIME_STAMP.mfg.ext3
tune2fs -j $IMAGE_DIR/$IMAGE-$MACHINE-$SCRIPT_TIME_STAMP.mfg.ext3

# remove the symlink
rm $IMAGE_DIR/$IMAGE-$MACHINE.mfg.ext3
ln -s $IMAGE_DIR/$IMAGE-$MACHINE-$SCRIPT_TIME_STAMP.mfg.ext3 $IMAGE_DIR/$IMAGE-$MACHINE.mfg.ext3

# clean up
rm -rf $MFG_TEMP_DIR

# write the mfgfs
dd if=$IMAGE_DIR/$IMAGE-$MACHINE.mfg.ext3 of=$SDCARD conv=notrunc seek=1 bs=$(expr $BOOT_SPACE_ALIGNED \* 1024 + $IMAGE_ROOTFS_ALIGNMENT \* 1024 + $ROOTFS_SIZE \* 1024) && sync && sync

# Setting partition type to 0x53 as required for mxs' SoC family
echo -n S | dd of=${SDCARD} bs=1 count=1 seek=450 conv=notrunc


parted ${SDCARD} print
















echo "SD card creation was successful"

exit 0;
