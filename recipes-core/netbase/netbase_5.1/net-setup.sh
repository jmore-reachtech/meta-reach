#!/bin/bash

USE_DHCP=1
STATIC_ADDRESS=
STATIC_NETMASK=
STATIC_GATEWAY=
AUTO="auto"
LO_IFACE="lo"
ETH0_IFACE="eth0"
INTERFACES_FILE="/etc/network/interfaces"
SAVE=0

do_get_static() {
	echo "Enter Address:"
	read STATIC_ADDRESS

	echo "Enter Netmask:"
	read STATIC_NETMASK

	echo "Enter Default Gateway:"
	read STATIC_GATEWAY
}

do_write_static() {
	echo ""
	echo "Using Static:"
	echo "--------------"
	echo "$AUTO $LO_IFACE"
	echo "iface $LO_IFACE inet loopback"
	echo ""
	echo "$AUTO $ETH0_IFACE"
	echo "iface $ETH0_IFACE inet static"
	echo "	address $STATIC_ADDRESS"
	echo "	netmask $STATIC_NETMASK"
	echo "	gateway $STATIC_GATEWAY"
	echo "--------------"

	echo ""
	echo "Would you like to save configuration? [ 1=Yes 0=No]"
	read SAVE

	if [ "$SAVE" -eq "$SAVE" ] 2>/dev/null; then
		if [ $SAVE -eq 1 ]; then
			echo "$AUTO $LO_IFACE" > $INTERFACES_FILE
			echo "iface $LO_IFACE inet loopback" >> $INTERFACES_FILE
			echo "" >> $INTERFACES_FILE
			echo "$AUTO $ETH0_IFACE" >> $INTERFACES_FILE
			echo "iface $ETH0_IFACE inet static" >> $INTERFACES_FILE
			echo "	address $STATIC_ADDRESS" >> $INTERFACES_FILE
			echo "	netmask $STATIC_NETMASK" >> $INTERFACES_FILE
			echo "	gateway $STATIC_GATEWAY" >> $INTERFACES_FILE
			echo "" >> $INTERFACES_FILE
			sync
			echo "Configuration saved.  Please reboot."
		else
			echo "Configuration not saved."			
		fi
	else
		echo "Invalid option, exiting..."
		exit 1
	fi
}

do_write_dhcp() {
	echo ""
	echo "Using DHCP:"
	echo "--------------"
	echo "$AUTO $LO_IFACE"
	echo "iface $LO_IFACE inet loopback"
	echo ""
	echo "$AUTO $ETH0_IFACE"
	echo "iface $ETH0_IFACE inet dhcp"
	echo "--------------"

	echo ""
	echo "Would you like to save configuration? [ 1=Yes 0=No]"
	read SAVE

	if [ "$SAVE" -eq "$SAVE" ] 2>/dev/null; then
		if [ $SAVE -eq 1 ]; then
			echo "$AUTO $LO_IFACE" > $INTERFACES_FILE
			echo "iface $LO_IFACE inet loopback" >> $INTERFACES_FILE
			echo "" >> $INTERFACES_FILE
			echo "$AUTO $ETH0_IFACE" >> $INTERFACES_FILE
			echo "iface $ETH0_IFACE inet dhcp" >> $INTERFACES_FILE
			echo "" >> $INTERFACES_FILE
			sync
			echo "Configuration saved.  Please reboot."
		else
			echo "Configuration not saved."			
		fi
	else
		echo "Invalid option, exiting..."
		exit 1
	fi
}

do_prompt_for_network() {
	echo "Do you want to use DHCP or Static addressing? [1=DHCP 0=Static]"
	read USE_DHCP
}

clear
do_prompt_for_network

if [ "$USE_DHCP" -eq "$USE_DHCP" ] 2>/dev/null; then
	if [ "$USE_DHCP" -eq 1 ]; then
		do_write_dhcp

		exit 0
	fi

	if [ "$USE_DHCP" -eq 0 ]; then
		do_get_static
	
		do_write_static

		exit 0
	fi
else
	echo "Invalid option, exiting..."
	exit 1
fi




