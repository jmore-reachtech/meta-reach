LICENSE = "MIT"

inherit core-image

CORE_IMAGE_EXTRA_INSTALL = "\
    reach-installer \
    u-boot-fw-utils \
"

do_rootfs[depends] += "reach-image-minimal:do_rootfs"

reach_installer_image_copy_installer_data() {
    local installer_datadir=${IMAGE_ROOTFS}/installer-data
    mkdir -p $installer_datadir
    cp -L ${DEPLOY_DIR_IMAGE}/zImage $installer_datadir/zImage
    cp -L ${DEPLOY_DIR_IMAGE}/reach-image-minimal-${MACHINE}.ubifs $installer_datadir/rootfs.ubifs
    cp -L ${DEPLOY_DIR_IMAGE}/u-boot.imx-g2h-*_spi_nor $installer_datadir/u-boot.imx
    for dtb_file in ${KERNEL_DEVICETREE}; do
        cp -L ${DEPLOY_DIR_IMAGE}/zImage-$dtb_file $installer_datadir/$dtb_file
    done
}

ROOTFS_POSTPROCESS_COMMAND += "reach_installer_image_copy_installer_data;"
