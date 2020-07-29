#!/bin/sh
#==================================================
#
# updated: 07/24/20 Reach Technology
#
# this script controls a system critical function
# and must not be put under control of chkconfig
#
#==================================================

. /etc/default/rcS

printf "\nResizing /data filesystem\n"

#
# figure out the root and data devices
#
ROOTDEV=`mount | grep 'on / ' | cut -f1 -d ' '`
printf "  /\ton %s\n" ${ROOTDEV}
DATADEV=`echo ${ROOTDEV} | sed s:p2:p4:`
printf "  /data\ton %s\n" ${DATADEV}

#
# run fsck on the data filesystem
#
printf "\n  checking filesystem on /data (%s)\n" ${DATADEV}
fsck -y ${DATADEV}

#
# resize the data filesystem
#
printf "\n  expanding /data filesystem (%s) to use available space\n" ${DATADEV}
resize2fs -f ${DATADEV}

#
# rerun fsck on the data filesystem
#
printf "\n  rechecking expanded filesystem on /data (%s)\n" ${DATADEV}
fsck -y ${DATADEV}

#
# remove the rcS/S link so this does not run again
#
rm -f /etc/rcS.d/S03data-fs-resize.sh

printf "\n  /data filesystem expansion complete\n\n"
: exit 0
