DESCRIPTION = "A minimal console based image used for testing"

LICENSE = "MIT"


IMAGE_INSTALL_append = "\
	${CORE_IMAGE_BASE_INSTALL} \
	packagegroup-custom-dev-tools \
	packagegroup-custom-core \
	tslib \
	tslib-calibrate \
	tslib-tests \
	tsinit \
	usbutils \
    reach-info \
    bc \
    coreutils \
    psplash \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-mfg"
