#!/bin/sh

case "$1" in
start)
        # show this during quiet boot too.
        echo "LCD start, nothing to do..." >&2
        ;;
stop)
        echo "stoping the LCD panel..."
        echo 1 > /sys/devices/soc0/fb.24/graphics/fb0/blank
        ;;
*)
        echo "Usage: /etc/init.d/lcd{start|stop}" >&2
        exit 1
        ;;
esac

exit 0
