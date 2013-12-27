DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r2"

SRCREV = "09f228342aa9d741ef3bc75b1b61b9c2d621c5fc"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo.git;protocol=ssh"

S = "${WORKDIR}/git/"

APP_DIR="/application/src"

do_install() {
	install -d ${D}${APP_DIR}

	cp -rf ${WORKDIR}/git/src/*	${D}${APP_DIR}
}

FILES_${PN} = "${APP_DIR}"

