DESCRIPTION = "A minimal console based image used for testing"

LICENSE = "MIT"

IMAGE_OVERHEAD_FACTOR = "2.0"

IMAGE_INSTALL_append = "\
    ${CORE_IMAGE_BASE_INSTALL} \
    packagegroup-custom-dev-tools \
    packagegroup-custom-dev-tools-gdb \
    tslib \
    tslib-calibrate \
    tslib-tests \
    tsinit \
    usbutils \
    bc \
    devregs \
    openssh-sshd \
    openssh-ssh \
    openssh-scp \
    openssh-sftp-server \
    ethtool \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-minimal"
