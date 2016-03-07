DESCRIPTION = "Reach X11 Custom Package"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-custom-x11-apps \
 packagegroup-custom-x11-tools \
"

RDEPENDS_packagegroup-custom-x11-apps = "\
         mesa-driver-swrast \
"
RDEPENDS_packagegroup-custom-x11-apps_mxs = "\
		 xserver-xorg-fbdev \
"

RDEPENDS_packagegroup-custom-x11-tools = "\
    xinput-calibrator \
"
