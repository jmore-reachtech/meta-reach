DESCRIPTION = "A minimal qt5 image without X11"

LICENSE = "MIT"

include qt5-versions.inc

TOUCH = "tslib tslib-calibrate tslib-tests"

BASE_REACH = " \
    busybox \
    busybox-mdev \
    base-passwd \
    base-files \
    reach-overlay-qt \
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

QT_REACH = "reach-qml-viewer-qt5 \
    reach-sio-agent \
    reach-tio-agent \
    qtbase-fonts \
    qtbase-plugins \
    qtbase-tools \
    dbus \
    reach-qml-plugins-imx \
    reach-qml-demo-qt5 \
    qtdeclarative \
    qtdeclarative-plugins \
    qtdeclarative-tools \
    qtdeclarative-qmlplugins \
    qtmultimedia \
    qtmultimedia-plugins \
    qtmultimedia-qmlplugins \
    qtwebkit \
    qtwebkit-qmlplugins \
"
GSTREAMER_REACH = "packagegroup-fsl-gstreamer \
    gstreamer \
    gst-plugins-base-app \
    gst-plugins-base \
    gst-plugins-good \
    gst-plugins-good-rtsp \
    gst-plugins-good-udp \
    gst-plugins-good-rtpmanager \
    gst-plugins-good-rtp \
    gst-plugins-good-video4linux2 \
    firmware-imx-vpu-imx6d \
"

IMAGE_INSTALL_append = "\
    ${TOUCH} \
    ${BASE_REACH} \
    ${QT_REACH} \
    ${GSTREAMER_REACH} \
"

inherit image

export IMAGE_BASENAME="reach-image-qt5-tiny"

do_rootfs[depends] += " mtd-utils-native:do_populate_sysroot "
