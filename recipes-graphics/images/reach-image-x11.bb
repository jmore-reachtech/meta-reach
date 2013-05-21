include recipes-graphics/images/core-image-x11.bb

IMAGE_INSTALL += "xserver-xorg-fbdev"

export IMAGE_BASENAME = "reach-image-x11"

