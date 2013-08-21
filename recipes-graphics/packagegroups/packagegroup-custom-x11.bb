DESCRIPTION = "Reach X11 Custom Package"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-custom-x11-apps \
 packagegroup-custom-x11-tools \
 packagegroup-custom-x11-touch-init \
"

RDEPENDS_packagegroup-custom-x11-apps = "\
		 xserver-xorg-fbdev \
         tslib \
         mesa-driver-swrast \
"

RDEPENDS_packagegroup-custom-x11-tools = "\
         tslib-tests \
         tslib-calibrate \
"

RDEPENDS_packagegroup-custom-x11-touch-init = "\
         tsinit \
"
