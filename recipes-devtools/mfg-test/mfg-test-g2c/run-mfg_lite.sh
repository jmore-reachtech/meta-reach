#! /bin/bash
# (c) Copyright 2013 Reach Technology <jhorn@reachtehc.com>
# Licensed under terms of GPLv2
#
MAC_1=30688C

TESTS="Ethernet,TouchScreen,LCD,Backlight,AUART"
SD_MNT_DIR=/tmp/sdcard
MTD_NUM=1

clear
echo "Running the following tests: $TESTS"
echo ""

/usr/sbin/mfg-test --tests $TESTS

echo "Scan the mac address: "
read MAC_2
/usr/sbin/mfg-test --mac-address=${MAC_1}${MAC_2}
echo ""

while true; do
    read -p "Do you wish to copy the SD Card to NAND? [Type Y or N]: " yn
    case $yn in
        [Yy]* ) mkdir -p /images; 
				mount /dev/mmcblk0p3 /images; 
				flash_install.sh; 
				
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
				break;;
				
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
	rm /etc/udev/rules.d/70-persistent-net.rules
fi

sync && sync
