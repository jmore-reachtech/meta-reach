DESCRIPTION = "A very basic X11 image with a terminal"

IMAGE_FEATURES += "splash x11-base package-management"

LICENSE = "MIT"

IMAGE_OVERHEAD_FACTOR = "2.0"

IMAGE_INSTALL_append = " packagegroup-custom-x11-apps \
	packagegroup-custom-x11-tools \
	packagegroup-custom-dev-tools \
	packagegroup-custom-dev-tools-gdb \
	packagegroup-custom-core \
	gtk+-demo \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-x11"

