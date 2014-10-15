DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRCREV = "8e4a2d84745876e193952ccbfae6a5ee40245470"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo-qt5.git;protocol=http"

S_BASE = "${WORKDIR}/git/src"
APP_DIR = "/application/src"

do_install() {
        install -d ${D}${APP_DIR}

        cp -rf ${S_BASE}/*   ${D}${APP_DIR}
}

FILES_${PN} = "${APP_DIR}"

