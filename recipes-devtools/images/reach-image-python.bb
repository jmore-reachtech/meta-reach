DESCRIPTION = "A very basic python image with a terminal"

IMAGE_FEATURES += "splash x11 package-management"

LICENSE = "MIT"

IMAGE_OVERHEAD_FACTOR = "2.0"

TOUCH = "tslib tslib-tests tslib-calibrate"

IMAGE_INSTALL_append = " ${TOUCH} \
	packagegroup-custom-dev-tools \
	packagegroup-custom-dev-tools-gdb \
	packagegroup-custom-core \
        xf86-input-tslib \
        python-pyserial \
        python-numpy \
        python-pip \
        python \
        python-dbg \
        python-modules \
        python-misc \
        python-docutils \
        python-distribute \
        python-pygtk \
        gcc \
        gdb \
        curl \
        python-demo \
        xterm \
        xeyes \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-python"

