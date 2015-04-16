DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r3"

SRCREV = "cfdd6aed6dc0b9aad8e4f3bd7c0d4db8bf50d9c9"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo.git;protocol=ssh"

S_BASE = "${WORKDIR}/git/src"
APP_DIR = "/application/src"

do_install() {
        install -d ${D}${APP_DIR}

        cp -rf ${S_BASE}`echo "${MACHINE}" | cut -c4-`/*   ${D}${APP_DIR}
}

FILES_${PN} = "${APP_DIR}"

