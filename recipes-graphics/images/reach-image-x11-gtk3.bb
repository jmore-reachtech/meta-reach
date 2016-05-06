DESCRIPTION = "A very basic X11 image with a terminal and gtk+3 support"

IMAGE_FEATURES += "splash x11-base package-management"

LICENSE = "MIT"

IMAGE_OVERHEAD_FACTOR = "2.0"

IMAGE_INSTALL_append = "\
    packagegroup-custom-x11-apps \
    packagegroup-custom-x11-tools \
    packagegroup-custom-dev-tools \
    packagegroup-custom-dev-tools-gdb \
    packagegroup-custom-core \
    gtk+3 \
    gtk+3-demo \
    i2c-tools \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-x11-gtk3"
