#! /bin/bash
# (c) Copyright 2013 Reach Technology <jhorn@reachtehc.com>
# Licensed under terms of GPLv2
#
MAC_1=30688C

TESTS="Ethernet,USB1,USB2,LCD,Backlight,AUART"
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

if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
        rm /etc/udev/rules.d/70-persistent-net.rules
fi

sync && sync
