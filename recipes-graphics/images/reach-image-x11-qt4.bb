include recipes-graphics/images/core-image-x11.bb

IMAGE_FEATURES += "debug-tweaks"
DISTRO_FEATURES += "pulseaudio"
WEB = "web-webkit"

SOC_EXTRA_IMAGE_FEATURES ?= "tools-testapps"

# Add extra image features
EXTRA_IMAGE_FEATURES += " \
    ${SOC_EXTRA_IMAGE_FEATURES} \
    nfs-server \
    tools-debug \
    tools-profile \
    qt4-pkgs \
"

SOC_IMAGE_INSTALL = ""
SOC_IMAGE_INSTALL_mx5 = "glcubes-demo"

IMAGE_INSTALL += " \
    ${SOC_IMAGE_INSTALL} \
    packagegroup-fsl-gstreamer \
    packagegroup-fsl-tools-testapps \
    qt4-plugin-phonon-backend-gstreamer \
    qt4-demos \
    qt4-examples \
    fsl-gui-extrafiles \
    reach-qml-viewer-qt4x11 \
    reach-sio-agent \
    reach-tio-agent \
	sciton-qml-demo \
	packagegroup-custom-core \
    "

export IMAGE_BASENAME = "reach-image-x11-qt4"
