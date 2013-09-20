DESCRIPTION = "Reach QML Viewer and init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

inherit qt4e

PR = "r3"

SRCREV = "3c9e4e601693eb383c9810e4d27f180eb6f4d94f"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-viewer.git;protocol=ssh \
		   file://reset-app.sh \
		   file://qml-viewer \
          "

FILES_${PN} += "${sysconfdir}/init.d/qml-viewer ${sysconfdir}/init.d/qml-reset"

S = "${WORKDIR}/git"

APP_DIR="/application/bin"

do_install() {
	install -d ${D}${APP_DIR}
	install -m 0755 ${S}/qml-viewer ${D}${APP_DIR}

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/qml-viewer ${D}${sysconfdir}/init.d/qml-viewer
	
	install -d ${D}/home/root
	install -m 0755 ${WORKDIR}/reset-app.sh ${D}/home/root
}

FILES_${PN} += "${APP_DIR} /home/root"
FILES_${PN}-dbg += "${APP_DIR}/.debug /usr/src/debug"

inherit update-rc.d

INITSCRIPT_NAME = "qml-viewer"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."
