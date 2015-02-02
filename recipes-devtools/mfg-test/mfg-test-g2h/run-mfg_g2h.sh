#! /bin/sh
# (c) Copyright 2013 Reach Technology <jhorn@reachtehc.com>
# Licensed under terms of GPLv2
#
MAC_1=30688C

TESTS="Ethernet,USB1,USB2,LCD,Backlight,AUART,GPIO,CAN0"
SD_MNT_DIR=/tmp/sdcard
MTD_NUM=1

clear
echo "Running the following tests: $TESTS"
echo ""

/usr/sbin/mfg-test --tests $TESTS

/usr/bin/amixer set PCM 80% 2>&1 /dev/null
/usr/bin/amixer set Headphone 90% 2>&1 /dev/null

read -p "Press Enter to test the speaker " PASS
/usr/bin/aplay /home/root/beep.wav

read -p "Did you hear the speaker? [Type Y or N] " PASS
case $PASS in
	[Yy]* ) echo ""
		echo -e "Speaker Test"'\t\t'$PASS_STR 
	;;
	[Nn]* ) echo -e "Speaker Test"'\t\t'$FAIL_STR 
		break
	;; 
esac

echo "Scan the mac address: "
read MAC_2
/usr/sbin/mfg-test --mac-address=${MAC_1}${MAC_2}
echo ""

if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
        rm /etc/udev/rules.d/70-persistent-net.rules
fi

read -p "Do all the above tests show [Pass]? [Type Y or N] " PASS
case $PASS in
	[Yy]* ) echo ""
		echo "Test Complete"
		echo ""
	;;
	[Nn]* ) echo ""
		break
	;; 
esac


sync && sync
