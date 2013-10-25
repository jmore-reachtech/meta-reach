#!/bin/sh
# (c) Copyright 2013 Reach Technology <jhorn@reachtech.com>
# Licensed under terms of GPLv2
#

SD_MNT_DIR=/tmp/sdcard
MTD_NUM=1

ATTR_GREEN='\033[0;32m'
ATTR_RED='\033[0;31m'
ATTR_NONE='\033[0m'

PASS_STR=$ATTR_GREEN"[PASS]"$ATTR_NONE
FAIL_STR=$ATTR_RED"[FAIL]"$ATTR_NONE


/usr/bin/ts_calibrate

sync && sync

# copy over pointer cal
echo "Copying calibration file to NAND"
mkdir -p $SD_MNT_DIR
if [ -c /dev/ubi0_0 ]; then
	/usr/sbin/ubidetach /dev/ubi_ctrl -m $MTD_NUM
fi
/usr/sbin/ubiattach /dev/ubi_ctrl -d 0 -m $MTD_NUM
sleep 3
mount -t ubifs /dev/ubi0_0 $SD_MNT_DIR
cp /etc/pointercal $SD_MNT_DIR/etc/
sync
umount $SD_MNT_DIR
/usr/sbin/ubidetach /dev/ubi_ctrl -m $MTD_NUM
sleep 3
rmdir $SD_MNT_DIR
