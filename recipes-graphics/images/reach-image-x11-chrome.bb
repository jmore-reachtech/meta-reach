DESCRIPTION = "A very basic X11 image with a terminal"

IMAGE_FEATURES += "splash x11 package-management"

LICENSE = "MIT"

IMAGE_OVERHEAD_FACTOR = "2.0"

IMAGE_INSTALL_append = "\
	packagegroup-custom-dev-tools \
	packagegroup-custom-dev-tools-gdb \
	packagegroup-custom-core \
        chromium \
        libav \
        xinput-calibrator \
        libexif \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-x11-chrome"

# Add these layers for chromium:
# meta-browser 
# openembedded/meta-gnome 
#
# https://github.com/OSSystems/meta-browser
