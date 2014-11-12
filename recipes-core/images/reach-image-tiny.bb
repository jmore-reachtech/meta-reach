DESCRIPTION = "A tiny image"

LICENSE = "MIT"

IMAGE_INSTALL_append = "\
    ${CORE_IMAGE_BASE_INSTALL} \
    usbutils \
    devregs \
    openssh-sshd \
    openssh-ssh \
    openssh-scp \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-tiny"
