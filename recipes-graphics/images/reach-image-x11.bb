include recipes-graphics/images/core-image-x11.bb

IMAGE_INSTALL += "xserver-xorg-fbdev \
	packagegroup-custom-x11-apps \
	packagegroup-custom-x11-tools \
	packagegroup-custom-dev-tools \
"

export IMAGE_BASENAME = "reach-image-x11"

