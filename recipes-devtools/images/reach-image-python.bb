DESCRIPTION = "A very basic python image with a terminal"

IMAGE_FEATURES += "splash x11-base package-management"

LICENSE = "MIT"

IMAGE_OVERHEAD_FACTOR = "2.0"

IMAGE_INSTALL_append = " packagegroup-custom-x11-apps \
	packagegroup-custom-x11-tools \
	packagegroup-custom-dev-tools \
	packagegroup-custom-dev-tools-gdb \
	packagegroup-custom-x11-touch-init \
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
"

inherit core-image

export IMAGE_BASENAME = "reach-image-python"

