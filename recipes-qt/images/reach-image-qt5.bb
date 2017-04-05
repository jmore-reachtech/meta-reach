DESCRIPTION = "A minimal qt5 image without X11"

LICENSE = "MIT"

include qt5-versions.inc

IMAGE_OVERHEAD_FACTOR = "1.5"

TOUCH = "tslib tslib-calibrate tslib-tests"

IMAGE_INSTALL_append = "\
    ${CORE_IMAGE_BASE_INSTALL} \
    ${TOUCH} \
    packagegroup-custom-core \
    packagegroup-custom-dev-tools-gdb \
    packagegroup-custom-dev-tools \
    firmware-imx-vpu-imx6d \
    linux-firmware \
    packagegroup-fsl-gstreamer \
    gstreamer \
    gst-plugins-base-app \
    gst-plugins-base \
    gst-plugins-good \
    gst-plugins-good-rtsp \
    gst-plugins-good-udp \
    gst-plugins-good-rtpmanager \
    gst-plugins-good-rtp \
    gst-plugins-good-video4linux2 \
    qtbase-fonts \
    qtbase-plugins \
    qtbase-tools \
    qtdeclarative \
    qtdeclarative-plugins \
    qtdeclarative-tools \
    qtdeclarative-qmlplugins \
    qtmultimedia \
    qtmultimedia-plugins \
    qtmultimedia-qmlplugins \
    qtsvg \
    qtsvg-plugins \
    qtsensors \
    qtimageformats-plugins \
    qtsystems \
    qtsystems-tools \
    qtsystems-qmlplugins \
    qtscript \
    qt3d \
    qt3d-examples \
    qt3d-qmlplugins \
    qt3d-tools \
    qtwebkit \
    qtwebkit-qmlplugins \
    imx-test \    
    reach-qml-viewer-qt5 \
    reach-sio-agent \
    reach-tio-agent \
    reach-eio-agent \
    alsa-utils \
    alsa-state \
    reach-qml-plugins-imx \
    reach-qml-demo-qt5 \
    reach-gpio \
    i2c-tools \
    strace \
    wireless-tools \
    canutils \
    ifplugd-init \
    flash-installer \
    reach-fb2image-qt5 \
"

IMAGE_INSTALL_append_g2h = "\
        u-boot-g2h \
"

inherit core-image

do_rootfs[depends] += " mtd-utils-native:do_populate_sysroot "

write_reach_part_number() {
    # add reach partnumber
    echo ${REACH_PN} > ${IMAGE_ROOTFS}/etc/reach-pn
}

ROOTFS_POSTPROCESS_COMMAND_append = " \
    write_reach_part_number; \
"
