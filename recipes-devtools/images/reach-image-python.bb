DESCRIPTION = "A very basic python image with a terminal"

IMAGE_FEATURES += " x11 splash package-management"
IMAGE_FEATURES_g2c += " x11-base"

LICENSE = "MIT"

IMAGE_OVERHEAD_FACTOR = "2.0"

TOUCH = "tslib tslib-tests tslib-calibrate"

IMAGE_INSTALL_append = " ${TOUCH} \
	packagegroup-custom-dev-tools \
	packagegroup-custom-dev-tools-gdb \
	packagegroup-custom-core \
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
IMAGE_INSTALL_append_g2h += " \
        xf86-input-tslib \
"

IMAGE_INSTALL_append_g2c += " \
  xserver-xorg-fbdev \
  tsinit \
         mesa-driver-swrast \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-python"

