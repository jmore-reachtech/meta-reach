DESCRIPTION = "An image that will launch into a single QML page for the g2c-lite embedded version of Qt."

IMAGE_FEATURES += "splash package-management"

LICENSE = "MIT"

IMAGE_INSTALL_append = " \
	${CORE_IMAGE_BASE_INSTALL} \
	packagegroup-custom-core \
	packagegroup-reach-qt4e \
	packagegroup-reach-qml-viewer-qt4e \
        reach-app-loader \
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
"

inherit core-image

export IMAGE_BASENAME = "reach-image-app-loader"
