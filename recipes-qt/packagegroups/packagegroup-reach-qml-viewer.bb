SUMMARY = "Reach qml-viewer and agent apps"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = " \
        reach-qml-viewer \
        reach-sio-agent \
        reach-tio-agent \
"
