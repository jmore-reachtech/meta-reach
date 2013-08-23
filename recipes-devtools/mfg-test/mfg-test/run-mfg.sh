#!/bin/sh
# (c) Copyright 2013 Reach Technology <jhorn@reachtehc.com>
# Licensed under terms of GPLv2
#

MAC_1=30688C
TESTS="Ethernet,USBOTG,I2C,CAN0,AUART,RS485,RTC,GPIO,USB1,USB2,Touchscreen,LCD,Backlight"

clear
echo "Running the following tests: $TESTS"
echo ""

/usr/sbin/mfg-test --rtc-if ETHERNET --tests $TESTS

echo ""
echo "Scan the mac address: "
read MAC_2
/usr/sbin/mfg-test --mac-address=${MAC_1}${MAC_2}
echo ""

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

