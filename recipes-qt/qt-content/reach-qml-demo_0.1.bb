DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r2"

SRCREV = "5856247fd50a5b61afd8524becfbe155d0c1e33b"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo.git;protocol=ssh"

S = "${WORKDIR}/git/"

APP_DIR="/application/src"

do_install() {
	install -d ${D}${APP_DIR}

	cp -rf ${WORKDIR}/git/src/*	${D}${APP_DIR}
}

FILES_${PN} = "${APP_DIR}"

