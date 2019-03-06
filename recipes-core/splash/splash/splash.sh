#!/bin/sh 
### BEGIN INIT INFO
# Provides:             splash
# Required-Start:
# Required-Stop:
# Default-Start:        S
# Default-Stop:
### END INIT INFO

SPLASH_BMP=/data/splash.bmp

if [ ! -e /dev/fb0 ]; then
    echo "Framebuffer /dev/fb0 not detected"
    echo "Boot splashscreen disabled"
    exit 0;
fi

if [ ! -e $SPLASH_BMP ]; then
    echo "Splash bitmap file not detected"
    echo "Boot splashscreen disabled"
    exit 0;
fi

read CMDLINE < /proc/cmdline
for x in $CMDLINE; do
        case $x in
        splash=false)
		echo "Boot splashscreen disabled" 
		exit 0;
                ;;
        esac
done

/usr/bin/fbi -vt 1 -d /dev/fb0 --noverbose $SPLASH_BMP
