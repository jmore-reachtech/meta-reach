#!/bin/sh

# base IO and full IO have different device numbers
if [ -d /sys/devices/soc0/fb.24 ]; then
	BLANK=/sys/devices/soc0/fb.24/graphics/fb0/blank
elif [ -d /sys/devices/soc0/fb.26 ]; then
    BLANK=/sys/devices/soc0/fb.26/graphics/fb0/blank
else
    BLANK=/dev/null
fi

case "$1" in
start)
        # show this during quiet boot too.
        echo "LCD start, nothing to do..." >&2
        ;;
stop)
        echo "stoping the LCD panel..."
        echo 1 > ${BLANK}
        ;;
*)
        echo "Usage: /etc/init.d/lcd{start|stop}" >&2
        exit 1
        ;;
esac

exit 0
