DESCRIPTION = "Reach X11 Custom Package"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-custom-x11-apps \
 packagegroup-custom-x11-tools \
"

RDEPENDS_packagegroup-custom-x11-apps = "\
         tslib \
"

RDEPENDS_packagegroup-custom-x11-tools = "\
         tslib-tests \
         tslib-calibrate \
"
