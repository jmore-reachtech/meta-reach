DESCRIPTION = "A minimal console based image used for testing"

LICENSE = "MIT"


IMAGE_INSTALL_append = "\
	${CORE_IMAGE_BASE_INSTALL} \
	packagegroup-custom-dev-tools \
	tslib \
	tslib-calibrate \
	tslib-tests \
	tsinit \
	usbutils \
    bc \
    coreutils \
    psplash \
    mfg-test-g2c \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-mfg"

COMPATIBLE_MACHINE = "(g2c)"
