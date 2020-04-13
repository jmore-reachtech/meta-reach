#!/bin/sh
#==================================================
#
# updated: 03/22/20 Reach Technology
#
# this script controls a system critical function
# and must not be put under control of chkconfig
#
#==================================================

if test -f /etc/nologin.boot
then
	rm -f /etc/nologin /etc/nologin.boot
fi

: exit 0
