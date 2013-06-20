DESCRIPTION = "An image that will launch into the demo application for the embedded (not based on X11) version of Qt."

IMAGE_FEATURES += "splash"

LICENSE = "MIT"

IMAGE_INSTALL_append = "\
	${CORE_IMAGE_BASE_INSTALL} \
	reach-version \
	packagegroup-reach-qt4e \
        reach-qml-demo \
        qml-viewer-init \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-qt4e-demo"

