#!/bin/sh

export TMPDIR=/mnt/.psplash

# set a default PN
SN=S000-000

if [ -f /etc/reach-pn ]; then
	SN=$(cat /etc/reach-pn)
elif [ -f /etc/reach-version ]; then
	SN=$(cat /etc/reach-version  |grep "^meta-reach"|awk '{print $3}' | cut -c1-8)
fi

if [ "$(rdev)" = "" ]; then
    SN=${SN}-NAND  
fi
                                                                              
/usr/bin/psplash-write "MSG $SN"
