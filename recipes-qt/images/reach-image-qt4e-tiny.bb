DESCRIPTION = "A minimal qt5 image without X11"

LICENSE = "MIT"

TOUCH = "tslib tslib-calibrate tslib-tests tsinit"

TOUCH = "tslib tslib-calibrate tslib-tests"

BASE_REACH = " \
    busybox \
    busybox-mdev \
    base-passwd \
    base-files \
    reach-overlay-qt4e \
    reach-info \
    netbase \
    php-cgi \
    kernel-modules \
    samba-lite \
    wpa-supplicant \
    wireless-tools \
    kmod \
    linux-firmware-ralink \
    bash \
"

QT_REACH = "\
    packagegroup-reach-qt4e \
    packagegroup-reach-qml-viewer-qt4e \
    reach-qml-demo \
"

IMAGE_INSTALL_append = "\
    ${TOUCH} \
    ${BASE_REACH} \
    ${QT_REACH} \
"

inherit image

export IMAGE_BASENAME="reach-image-qt4e-tiny"

do_rootfs[depends] += " mtd-utils-native:do_populate_sysroot "
