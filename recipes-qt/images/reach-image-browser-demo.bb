DESCRIPTION = "Qt5 image with a Qt Webengine browser demo"
LICENSE = "MIT"

include qt5-versions.inc

inherit core-image

TOUCH = "tslib tslib-calibrate tslib-tests"

IMAGE_INSTALL_append = " \
    ${CORE_IMAGE_BASE_INSTALL} \
    ${TOUCH} \
    alsa-state \
    alsa-utils \
    browser-demo \
    evtest \
    firmware-imx-vpu-imx6d \
    imx-test \
    linux-firmware \
    qtbase-plugins \
    qtbase-tools \
    qtwebengine \
    qtwebengine-qmlplugins \
    u-boot-fw-utils \
    ca-certificates \
    liberation-fonts \
"

IMAGE_INSTALL_append_g2h = " \
    u-boot-reach \
"

do_rootfs[depends] += " mtd-utils-native:do_populate_sysroot "

export IMAGE_BASENAME="reach-image-browser-demo"

IMAGE_FSTYPES += "ubifs"

IMAGE_FEATURES += "ssh-server-openssh"
