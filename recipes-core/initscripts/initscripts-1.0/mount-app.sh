#!/bin/sh

HAS_UBI=$(grep -ci ubifs /proc/cmdline)

case "$1" in
start)
        # show this during quiet boot too.
        echo "Mounting application partition..." >&2
        if [ "$HAS_UBI" -eq "1" ]; then
			/usr/sbin/ubiattach /dev/ubi_ctrl -d 1 -m 1
			/bin/mount -t ubifs /dev/ubi1_0 /application
        else
			/bin/mount /dev/mmcblk0p3 /application
        fi
        ;;
stop)
        echo "Unmounting application partition..."
        if [ "$HAS_UBI" -eq "1" ]; then
			/bin/umount  /application
			/usr/sbin/ubidetach /dev/ubi_ctrl -m 1
        else
			/bin/umount	/application
        fi
        ;;
*)
        echo "Usage: /etc/init.d/lcd{start|stop}" >&2
        exit 1
        ;;
esac

exit 0
