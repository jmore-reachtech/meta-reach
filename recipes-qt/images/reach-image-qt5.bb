DESCRIPTION = "A minimal qt5 image without X11"

LICENSE = "MIT"

include qt5-versions.inc

IMAGE_OVERHEAD_FACTOR = "1.5"

TOUCH = "tslib tslib-calibrate tslib-tests"

E2FS = "e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs e2fsprogs-resize2fs"

IMAGE_INSTALL_append = "\
    ${CORE_IMAGE_BASE_INSTALL} \
    ${TOUCH} \
    ${E2FS} \
    mtd-utils \
    packagegroup-custom-core \
    packagegroup-custom-dev-tools-gdb \
    packagegroup-custom-dev-tools \
    firmware-imx-vpu-imx6d \
    linux-firmware \
    packagegroup-fsl-gstreamer1.0 \
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
    qtwebkit \
    qtwebkit-qmlplugins \
    imx-test \    
    reach-qml-viewer-qt5 \
    alsa-utils \
    alsa-state \
    reach-qml-plugins-imx \
    reach-qml-demo-qt5 \
    reach-gpio \
    i2c-tools \
    strace \
    iw \
    canutils \
    ifplugd-init \
    flash-installer \
    evtest \
    u-boot-fw-utils \
    reach-g2link \
    imx-codec \
    reach-fb2image-qt5 \
    liberation-fonts \
"

IMAGE_INSTALL_append_g2h = "\
        u-boot-reach \
"

inherit core-image

do_rootfs[depends] += " mtd-utils-native:do_populate_sysroot "

export IMAGE_BASENAME="reach-image-qt5"

IMAGE_FSTYPES += "ubifs"

write_reach_part_number() {
    # add reach partnumber
    echo ${REACH_PN} > ${IMAGE_ROOTFS}/etc/reach-pn
}

ROOTFS_POSTPROCESS_COMMAND_append = " \
    write_reach_part_number; \
"
