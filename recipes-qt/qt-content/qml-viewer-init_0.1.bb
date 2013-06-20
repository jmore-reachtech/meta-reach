DESCRIPTION = "Init script for qml-viewer demo"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r4"

SRC_URI = " \
           file://qml-viewer \
           file://qml-reset \
          "

do_install() {
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/qml-viewer ${D}${sysconfdir}/init.d/qml-viewer
	install -m 0755 ${WORKDIR}/qml-reset ${D}${sysconfdir}/init.d/qml-reset
}

inherit update-rc.d allarch

INITSCRIPT_NAME = "qml-viewer"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."
