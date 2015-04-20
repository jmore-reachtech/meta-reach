DESCRIPTION = "A minimal qt5 image without X11"

LICENSE = "MIT"

TOUCH = "tslib tslib-calibrate tslib-tests tsinit"

BASE_REACH = "busybox \
    busybox-mdev \
    base-passwd \
    base-files \
    reach-overlay \
    reach-info \
    netbase \
    php-cgi \
    reach-version \
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

do_rootfs[depends] += " mtd-utils-native:do_populate_sysroot "

export IMAGE_BASENAME="reach-image-qt4e-minimal"

add_mods () {
  tar -x -C ${IMAGE_ROOTFS} -f ${DEPLOY_DIR_IMAGE}/modules--2.6.35.3-r32.23-g2c-43-24-20150417195411.tgz
  KERNEL_VERSION=`cat ${STAGING_KERNEL_DIR}/kernel-abiversion`
  depmodwrapper -a -b ${IMAGE_ROOTFS} $KERNEL_VERSION
}

ROOTFS_POSTPROCESS_COMMAND += " add_mods ; "
