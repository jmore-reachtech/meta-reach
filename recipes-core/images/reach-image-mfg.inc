DESCRIPTION = "A minimal console based image used for testing"

inherit core-image

LICENSE = "MIT"

CORE_IMAGE_EXTRA_INSTALL += "\
    packagegroup-custom-dev-tools \
    usbutils \
    bc \
    coreutils \
    psplash \
    ${REACH_MFG_TEST_PACKAGE} \
"

export IMAGE_BASENAME = "reach-image-mfg"
