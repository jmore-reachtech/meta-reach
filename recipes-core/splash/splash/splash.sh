#!/bin/sh 
#==================================================
#
# updated: 03/22/20 Reach Technology
#
# this script controls a system critical function
# and must not be put under control of chkconfig
#
#==================================================

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
