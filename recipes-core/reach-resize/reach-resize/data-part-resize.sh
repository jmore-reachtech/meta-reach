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

#
# make sure /dev/initctl is there.
#
if test ! -p /dev/initctl
then
	rm -f /dev/initctl
	mknod -m 600 /dev/initctl p
fi
kill -USR1 1

printf "\nResizing /data partition\n"

#
# figure out the root and data devices
#
ROOTDEV=`mount | grep 'on / ' | cut -f1 -d ' '`
printf "  /\ton %s\n" ${ROOTDEV}
DATADEV=`echo ${ROOTDEV} | sed s:p2:p4:`
printf "  /data\ton %s\n" ${DATADEV}

#
# run fsck on the data partition
#
printf "\n  checking filesystem on /data (%s)\n" ${DATADEV}
fsck -y ${DATADEV}

#
# resize the data partition
#
printf "\n  expanding /data partition (%s) to use available space\n" ${DATADEV}
BLKDEV=${DATADEV::-2}
# echo "blkdev: ${BLKDEV}"
parted "${BLKDEV}" << EOF
print
resizepart 4
-1s
print
EOF

#
# remove the rcS/S link so this does not run again
#
rm -f /etc/rcS.d/S03data-part-resize.sh

#
# add the rcS/S link for the data FS resize so it runs on reboot
#
printf "\n  setting up for /data filesystem resize after reboot...\n"
(cd /etc/rcS.d; ln -s ../init.d/data-fs-resize.sh S03data-fs-resize.sh)

#
# reboot to make sure the kernel gets the update size
#
printf "\nRebooting to ensure kernel sees new partition size...\n\n"
sync
sync
reboot

