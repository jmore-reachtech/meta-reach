SUMMARY = "Reach qml-viewer and agent apps with X11"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-reach-qml-viewer-qt4x11 \
"

RDEPENDS_${PN} = " \
        reach-qml-viewer-qt4x11 \
        reach-sio-agent \
        reach-tio-agent \
        reach-eio-agent \
"
