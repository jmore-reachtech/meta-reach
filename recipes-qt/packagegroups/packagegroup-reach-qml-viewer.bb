SUMMARY = "Reach qml-viewer and agent apps"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-reach-qml-viewer-qt4e \
 packagegroup-reach-qml-viewer-qt4x11 \
"

RDEPENDS_${PN}-qt4e = " \
        reach-qml-viewer-qt4e \
        reach-qml-plugins-mxs \
        reach-sio-agent \
        reach-tio-agent \
"

RDEPENDS_${PN}-qt4x11 = " \
        reach-qml-viewer-qt4x11 \
        reach-sio-agent \
        reach-tio-agent \
"
