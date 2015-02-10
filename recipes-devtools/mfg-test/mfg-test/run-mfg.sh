#!/bin/sh
# (c) Copyright 2013 Reach Technology <jhorn@reachtehc.com>
# Licensed under terms of GPLv2
#

clear
echo "Testing vertical USBs"
echo ""

/usr/sbin/mfg-test --tests USB1,USB2,USBOTG

echo ""
echo ""
read -p "Switch to horizontal USB ports and press enter "


MAC_1=30688C
TESTS="Ethernet,USBOTG,I2C,CAN0,AUART,RS485,RTC,GPIO,USB1,USB2,Touchscreen,LCD,Backlight"
TONE=/usr/sbin/tone.sh
SD_MNT_DIR=/tmp/sdcard
MTD_NUM=1

ATTR_GREEN='\033[0;32m'
ATTR_RED='\033[0;31m'
ATTR_NONE='\033[0m'

PASS_STR=$ATTR_GREEN"[PASS]"$ATTR_NONE
FAIL_STR=$ATTR_RED"[FAIL]"$ATTR_NONE

clear
echo "Running the following tests: $TESTS"
echo ""

/usr/sbin/mfg-test --rtc-if ETHERNET --tests $TESTS

read -p "Press Enter to test the beeper " PASS

# test beeper
$TONE 3000 50
sleep 0.50
$TONE 3000 0

$TONE 3000 100
sleep 0.50
$TONE 3000 0

$TONE 3000 50
sleep 0.50
$TONE 3000 0

$TONE 3000 100
sleep 0.50
$TONE 3000 0

read -p "Did you hear the beeper? [Type Y or N] " PASS
case $PASS in
	[Yy]* ) echo ""
		echo -e "Beeper Test"'\t\t'$PASS_STR 
	;;
	[Nn]* ) echo -e "Beeper Test"'\t\t'$FAIL_STR 
		break
	;; 
esac

echo ""
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

read -p "Do all the above tests show [Pass]? [Type Y or N] " PASS
case $PASS in
	[Yy]* ) echo ""
		echo "The current RTC time is '$(hwclock -r)'. "
		echo "Please power down for 30 seconds. Then power up to"
		echo "re-check the time by typing 'hwclock -r'"
		echo ""
	;;
	[Nn]* ) echo ""
		break
	;; 
esac

