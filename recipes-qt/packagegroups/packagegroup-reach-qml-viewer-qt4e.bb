SUMMARY = "Reach qml-viewer and agent apps"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-reach-qml-viewer-qt4e \
"

RDEPENDS_${PN} = " \
        reach-qml-viewer-qt4e \
        reach-qml-plugins-mxs \
        reach-sio-agent \
        reach-tio-agent \
        reach-eio-agent \
        reach-io-demo \
"
