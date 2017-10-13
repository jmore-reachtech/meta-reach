#! /bin/sh
# (c) Copyright 2013 Reach Technology <jeff.horn@reachtech.com>
# Licensed under terms of GPLv2
#

# ENV vars for the manufacturing test
# Set the web server for the ethernet test download
#export TEST_WEB_SERVER_ADDR=<ip_address>

# Set the time server for the rtc test rdate command
#export TEST_RTC_SERVER_ADDR=<ip_address>

# Set the modules local IP address
#export TEST_MODULE_ADDR=<ip_address>

# Add a default gateway route
#export TEST_MODULE_GATEWAY=<ip_address>

MAC_1=30688C

TESTS="ETHERNET,USB1,LCD,AUART1,AUART3,AUART4,GPIO,CAN,I2C,FLASH,TOUCH,SPEAKER"
TESTS_ARGS=""

clear
echo "****************************************************************"
echo "* Manufacturing Test for Partnumber: $(cat /etc/reach-pn)"
echo "* Manufacturing Software Version: $(/usr/sbin/mfg-test --version)"
echo "****************************************************************"

echo ""
echo "Running the following tests: ${TESTS}"
echo ""

/usr/sbin/mfg-test ${TEST_ARGS} --tests ${TESTS}

echo "Scan the mac address: "
read MAC_2
/usr/sbin/mfg-test --mac-address=${MAC_1}${MAC_2}
echo ""

echo "Test Complete"

sync && sync
