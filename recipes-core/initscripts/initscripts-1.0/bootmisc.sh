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

. /etc/default/rcS
[ -f /etc/default/timestamp ] && . /etc/default/timestamp
#
# Put a nologin file in /etc to prevent people from logging in before
# system startup is complete.
#
if test "$DELAYLOGIN" = yes
then
  echo "System bootup in progress - please wait" > /etc/nologin
  cp /etc/nologin /etc/nologin.boot
fi

#
# Set pseudo-terminal access permissions.
#
if test -c /dev/ttyp0
then
	chmod 666 /dev/tty[p-za-e][0-9a-f]
	chown root:tty /dev/tty[p-za-e][0-9a-f]
fi

#
# Apply /proc settings if defined
#
SYSCTL_CONF="/etc/sysctl.conf"
if [ -f "${SYSCTL_CONF}" ]
then
	if [ -x "/sbin/sysctl" ]
	then
		# busybox sysctl does not support -q
		VERBOSE_REDIR="1>/dev/null"
		if [ "${VERBOSE}" != "no" ]; then
			VERBOSE_REDIR="1>&1"
		fi
		eval /sbin/sysctl -p "${SYSCTL_CONF}" $VERBOSE_REDIR
	else
		echo "To have ${SYSCTL_CONF} applied during boot, install package <procps>."
	fi
fi

#
# Update /etc/motd.
#
if test "$EDITMOTD" != no
then
	uname -a > /etc/motd.tmp
	sed 1d /etc/motd >> /etc/motd.tmp
	mv /etc/motd.tmp /etc/motd
fi

#
# This is as good a place as any for a sanity check
#
# Set the system clock from hardware clock
# If the timestamp is more recent than the current time,
# use the timestamp instead.
test -x /etc/init.d/hwclock.sh && /etc/init.d/hwclock.sh start
if test -e "$TIMESTAMP_FILE"
then
	SYSTEMDATE=`date -u +%4Y%2m%2d%2H%2M%2S`
	read TIMESTAMP < "$TIMESTAMP_FILE"
	if [ ${TIMESTAMP} -gt $SYSTEMDATE ]; then
		# format the timestamp as date expects it (2m2d2H2M4Y.2S)
		TS_YR=${TIMESTAMP%??????????}
		TS_SEC=${TIMESTAMP#????????????}
		TS_FIRST12=${TIMESTAMP%??}
		TS_MIDDLE8=${TS_FIRST12#????}
		date -u ${TS_MIDDLE8}${TS_YR}.${TS_SEC}
		test -x /etc/init.d/hwclock.sh && /etc/init.d/hwclock.sh stop
	fi
fi

#
# resize the EXT4 filesystem in eMMC partition 4
# if the semaphore file exists
#
if [ -e /.resize_emmc_part4 ]; then
	EMMC_PART4=/dev/mmcblk3p4
	if [ -e "${EMMC_PART4}" ]; then
		printf "\nresizing EXT4 filesystem in \"%s\"\n" "${EMMC_PART4}"
		resize2fs -f "${EMMC_PART4}"
	else
		printf "\neMMC partition 4 (%s) not found\n\nNOT resizing!\n\n" "${EMMC_PART4}"
	fi
	rm -f /.resize_emmc_part4
fi

: exit 0
