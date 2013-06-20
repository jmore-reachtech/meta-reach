DESCRIPTION = "Reach QML Viewer"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

inherit qt4e

PR = "r1"

SRCREV = "f24ed3d96cf4f23d5749eb2719a05578c71fba12"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-viewer.git;protocol=ssh"

S = "${WORKDIR}/git"

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${S}/qml-viewer ${D}/application/bin
}

FILES_${PN} = "/application/bin"
FILES_${PN}-dbg = "/application/bin/.debug /usr/src/debug"

