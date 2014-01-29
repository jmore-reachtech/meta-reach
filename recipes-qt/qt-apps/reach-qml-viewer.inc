DESCRIPTION = "Reach QML Viewer and init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r4"

SRCREV = "a62700d8703f8f0da3cac1cf8685f4c286b4af48"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-viewer.git;branch=add-system-class;protocol=ssh \
"

S = "${WORKDIR}/git"

APP_DIR="/application/bin"

do_install() {
	install -d ${D}${APP_DIR}
	install -m 0755 ${S}/qml-viewer ${D}${APP_DIR}
}

FILES_${PN} += "${APP_DIR} /home/root"
FILES_${PN}-dbg += "${APP_DIR}/.debug /usr/src/debug"

inherit update-rc.d
