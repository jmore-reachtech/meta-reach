DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r1"

SRCREV = "9f60f2d8172e73d330eeb7ee6b70d7c152e2d0e6"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo.git;protocol=ssh"

S = "${WORKDIR}/git/"

APP_DIR="/application/src"

do_install() {
	install -d ${D}${APP_DIR}
	install -m 0744 ${WORKDIR}/git/src/settings.conf ${D}/${APP_DIR}
	install -m 0744 ${WORKDIR}/git/src/translate.txt ${D}/${APP_DIR}

	cp -rf ${WORKDIR}/git/src/capacitive_coffeedemo     ${D}${APP_DIR}
	cp -rf ${WORKDIR}/git/src/components 				${D}${APP_DIR}
	cp -rf ${WORKDIR}/git/src/dialdemo           		${D}${APP_DIR}
	cp -rf ${WORKDIR}/git/src/images           			${D}${APP_DIR}
	cp -rf ${WORKDIR}/git/src/js       					${D}${APP_DIR}
	cp -rf ${WORKDIR}/git/src/resistive_coffeedemo		${D}${APP_DIR}
	cp -rf ${WORKDIR}/git/src/samegame					${D}${APP_DIR}
	cp -rf ${WORKDIR}/git/src/spedometerdemo			${D}${APP_DIR}
	cp -rf ${WORKDIR}/git/src/vumeterdemo				${D}${APP_DIR}
	cp -f ${WORKDIR}/git/src/mainmenu.qml				${D}${APP_DIR}
	cp -f ${WORKDIR}/git/src/mainview.qml				${D}${APP_DIR}
}

FILES_${PN} = "${APP_DIR}"

