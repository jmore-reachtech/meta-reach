DESCRIPTION = "An image that will launch into the demo application for the embedded (not based on X11) version of Qt."

IMAGE_FEATURES += "splash"

LICENSE = "MIT"

IMAGE_INSTALL_append = " \
	${CORE_IMAGE_BASE_INSTALL} \
	packagegroup-custom-core \
	packagegroup-reach-qt4e \
        packagegroup-reach-qml-viewer \
        reach-qml-demo \
       "

inherit core-image

export IMAGE_BASENAME = "reach-image-qt4e"

