DESCRIPTION = "A minimal console based image used for testing"

inherit core-image

LICENSE = "MIT"

IMAGE_INSTALL_append += "\
    ${CORE_IMAGE_BASE_INSTALL} \
    packagegroup-custom-dev-tools \
    tslib \
    tslib-calibrate \
    tslib-tests \
    usbutils \
    bc \
    ${REACH_MFG_TEST_PACKAGE} \
    devregs \
    openssh-sshd \
    openssh-ssh \
    openssh-scp \
    openssh-sftp-server \
    packagegroup-custom-dev-tools-gdb \
    i2c-tools \
"

export IMAGE_BASENAME = "reach-image-mfg"

write_reach_part_number() {
    # add reach partnumber
    echo ${REACH_PN} > ${IMAGE_ROOTFS}/etc/reach-pn
}

ROOTFS_POSTPROCESS_COMMAND_append = " \
    write_reach_part_number; \
"
