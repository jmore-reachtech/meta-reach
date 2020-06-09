#! /bin/sh
#==================================================
#
# updated: 03/22/20 Reach Technology
#
# this script controls a system critical function
# and must not be put under control of chkconfig
#
#==================================================
#
# WARNING:      If your hardware clock is not in UTC/GMT, this script
#               must know the local time zone. This information is
#               stored in /etc/localtime. This might be a problem if
#               your /etc/localtime is a symlink to something in
#               /usr/share/zoneinfo AND /usr isn't in the root
#               partition! The workaround is to define TZ either
#               in /etc/default/rcS, or in the proper place below.

[ ! -x /sbin/hwclock ] && exit 0

[ -f /etc/default/rcS ] && . /etc/default/rcS

[ "$UTC" = "yes" ] && tz="--utc" || tz="--localtime"
case "$1" in
        start)
                if [ "$VERBOSE" != no ]
                then
                        echo "System time was `date`."
                        echo "Setting the System Clock using the Hardware Clock as reference..."
                fi

		if [ "$HWCLOCKACCESS" != no ]
		then
			if [ -z "$TZ" ]
			then
	                   hwclock $tz --hctosys
			else
			   TZ="$TZ" hwclock $tz --hctosys
			fi
		fi

                if [ "$VERBOSE" != no ]
                then
                        echo "System Clock set. System local time is now `date`."
                fi
                ;;
        stop|restart|reload|force-reload)
		#
		# Updates the Hardware Clock with the System Clock time.
		# This will *override* any changes made to the Hardware Clock.
		#
		# WARNING: If you disable this, any changes to the system
		#          clock will not be carried across reboots.
		#
		if [ "$VERBOSE" != no ]
		then
			echo "Saving the System Clock time to the Hardware Clock..."
		fi
		if [ "$HWCLOCKACCESS" != no ]
		then
			hwclock $tz --systohc
		fi
		if [ "$VERBOSE" != no ]
		then
			echo "Hardware Clock updated to `date`."
		fi
                exit 0
                ;;
	show)
		if [ "$HWCLOCKACCESS" != no ]
		then
			hwclock $tz --show
		fi
		;;
        *)
                echo "Usage: hwclock.sh {start|stop|show|reload|restart}" >&2
		echo "       start sets kernel (system) clock from hardware (RTC) clock" >&2
		echo "       stop and reload set hardware (RTC) clock from kernel (system) clock" >&2
                exit 1
                ;;
esac
