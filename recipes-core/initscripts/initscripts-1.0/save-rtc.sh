#!/bin/sh
#==================================================
#
# updated: 03/22/20 Reach Technology
#
# this script controls a system critical function
# and must not be put under control of chkconfig
#
#==================================================

TIMESTAMP_FILE=/etc/timestamp

[ -f /etc/default/timestamp ] && . /etc/default/timestamp

# Update the timestamp
date -u +%4Y%2m%2d%2H%2M%2S 2>/dev/null > "$TIMESTAMP_FILE"
