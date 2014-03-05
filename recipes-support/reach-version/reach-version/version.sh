#!/bin/sh

export TMPDIR=/mnt/.psplash

SN=$(cat /etc/reach-version  |grep "^meta-reach"|awk '{print $3}' | cut -c1-8)
                                                                              
/usr/bin/psplash-write "MSG $SN"
