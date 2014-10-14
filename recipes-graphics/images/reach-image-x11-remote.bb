DESCRIPTION = "A very basic X11 image with a terminal"

IMAGE_FEATURES += "splash x11 package-management"

LICENSE = "MIT"

IMAGE_OVERHEAD_FACTOR = "2.0"

TOUCH = "tslib tslib-tests tslib-calibrate"

IMAGE_INSTALL_append = " ${TOUCH} \
	packagegroup-custom-dev-tools \
	packagegroup-custom-dev-tools-gdb \
	packagegroup-custom-core \
        xf86-input-tslib \
        x11-remote-demo \
        xterm \
        xeyes \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-x11-remote"

