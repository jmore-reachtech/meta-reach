DESCRIPTION = "Reach QML Viewer and init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

inherit qt4e

PR = "r2"

SRCREV = "f24ed3d96cf4f23d5749eb2719a05578c71fba12"
SRC_URI = " \
           git://git@github.com/jmore-reachtech/reach-qml-viewer.git;protocol=ssh \
          "

FILES_${PN} += "${sysconfdir}/init.d/qml-viewer ${sysconfdir}/init.d/qml-reset"

S = "${WORKDIR}/git"

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${S}/qml-viewer ${D}/application/bin

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/qml-viewer ${D}${sysconfdir}/init.d/qml-viewer
	install -m 0755 ${WORKDIR}/qml-reset ${D}${sysconfdir}/init.d/qml-reset
}

FILES_${PN} += "/application/bin"
FILES_${PN}-dbg += "/application/bin/.debug /usr/src/debug"

inherit update-rc.d

INITSCRIPT_NAME = "qml-viewer"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."