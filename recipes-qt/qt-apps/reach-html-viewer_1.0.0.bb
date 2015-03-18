DESCRIPTION = "Reach HTML Viewer and init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r1"

inherit qt4e

SRCREV ="3e94ae7fcdb81b4c7cb111a1bc847932396a1b28" 
SRC_URI = "git://git@github.com/jmore-reachtech/reach-html-viewer.git;protocol=ssh \
        file://html-viewer-qt4e \
        file://settings.conf \
"

S = "${WORKDIR}/git"

APP_DIR="/application/bin"
APP_BASE="/application"

FILES_${PN} += "${sysconfdir}/init.d/html-viewer"

do_install() {
        install -d ${D}${APP_DIR}
        install -d ${D}${sysconfdir}/init.d/
        install -m 0755 ${S}/html-viewer ${D}${APP_DIR}
        install -m 0755 ${WORKDIR}/settings.conf ${D}${APP_DIR}
        install -m 0755 ${WORKDIR}/html-viewer-qt4e ${D}${sysconfdir}/init.d/html-viewer

}

FILES_${PN} += "${APP_DIR} ${APP_BASE} /home/root"
FILES_${PN}-dbg += "${APP_DIR}/.debug /usr/src/debug"

inherit update-rc.d

INITSCRIPT_NAME = "html-viewer"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."
