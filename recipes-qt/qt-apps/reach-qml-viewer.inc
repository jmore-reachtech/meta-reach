DESCRIPTION = "Reach QML Viewer and init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r4"

SRCREV ="3c9e4e601693eb383c9810e4d27f180eb6f4d94f" 
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-viewer.git;branch=master;protocol=ssh \
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
