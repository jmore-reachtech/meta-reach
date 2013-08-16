DESCRIPTION = "A very basic X11 image with a terminal"

IMAGE_FEATURES += "splash x11-base"

LICENSE = "MIT"

IMAGE_INSTALL_append = " packagegroup-custom-x11-apps \
	packagegroup-custom-x11-tools \
	packagegroup-custom-dev-tools \
	packagegroup-custom-x11-touch-init \
	packagegroup-custom-core \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-x11"

