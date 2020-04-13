#!/bin/sh
#==================================================
#
# updated: 03/22/20 Reach Technology
#
# this script controls a system critical function
# and must not be put under control of chkconfig
#
#==================================================

if [ -e /proc/cpu/alignment ]; then
   echo "3" > /proc/cpu/alignment
fi

