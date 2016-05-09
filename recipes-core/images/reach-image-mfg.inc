DESCRIPTION = "A minimal console based image used for testing"

inherit core-image

LICENSE = "MIT"

CORE_IMAGE_EXTRA_INSTALL += "\
    packagegroup-custom-dev-tools \
    tslib \
    tslib-calibrate \
    tslib-tests \
    usbutils \
    bc \
    coreutils \
    ${REACH_MFG_TEST_PACKAGE} \
"

export IMAGE_BASENAME = "reach-image-mfg"
