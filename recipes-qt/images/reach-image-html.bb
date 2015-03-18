DESCRIPTION = "An image that will launch into the embedded Qt browser for EmpowerRF."

IMAGE_FEATURES += "splash"

LICENSE = "MIT"

IMAGE_INSTALL_append = " \
        ${CORE_IMAGE_BASE_INSTALL} \
        packagegroup-custom-core \
        packagegroup-reach-qt4e \
        reach-html-viewer \
        packagegroup-custom-dev-tools \
        packagegroup-custom-dev-tools-gdb \
        bc \
        coreutils \
        usbutils \
        wireless-tools \
        wpa-supplicant \
        linux-firmware-ar9271 \
        linux-firmware-sd8686 \
        linux-firmware-rtl8192cu \
        linux-firmware-rtl8192ce \
        linux-firmware-rtl8192su \
        nodejs \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-html"
