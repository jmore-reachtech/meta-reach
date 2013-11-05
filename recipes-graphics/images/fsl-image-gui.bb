include recipes-sato/images/core-image-sato.bb

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
    "

export IMAGE_BASENAME = "fsl-image-gui"
