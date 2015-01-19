DESCRIPTION = "A minimal qt5 image without X11"

LICENSE = "MIT"

include qt5-versions.inc

TOUCH = "tslib tslib-calibrate tslib-tests"

IMAGE_INSTALL_append = "\
    ${CORE_IMAGE_BASE_INSTALL} \
    ${TOUCH} \
    packagegroup-custom-core \
    packagegroup-custom-dev-tools-gdb \
    packagegroup-custom-dev-tools \
    firmware-imx-vpu-imx6d \
    packagegroup-fsl-gstreamer \
    gstreamer \
    gst-plugins-base-app \
    gst-plugins-base \
    gst-plugins-good \
    gst-plugins-good-rtsp \
    gst-plugins-good-udp \
    gst-plugins-good-rtpmanager \
    gst-plugins-good-rtp \
    gst-plugins-good-video4linux2 \
    qtbase-fonts \
    qtbase-plugins \
    qtbase-tools \
    qtdeclarative \
    qtdeclarative-plugins \
    qtdeclarative-tools \
    qtdeclarative-qmlplugins \
    qtmultimedia \
    qtmultimedia-plugins \
    qtmultimedia-qmlplugins \
    qtsvg \
    qtsvg-plugins \
    qtsensors \
    qtimageformats-plugins \
    qtsystems \
    qtsystems-tools \
    qtsystems-qmlplugins \
    qtscript \
    qt3d \
    qt3d-examples \
    qt3d-qmlplugins \
    qt3d-tools \
    qtwebkit \
    qtwebkit-qmlplugins \
    imx-test \    
    reach-qml-viewer-qt5 \
    reach-sio-agent \
    reach-tio-agent \
    reach-eio-agent \
    alsa-utils \
    alsa-state \
    psplash \
    reach-qml-plugins-imx \
    reach-qml-demo-qt5 \
    i2c-tools \
"

inherit core-image

export IMAGE_BASENAME = "reach-image-qt5"

