DESCRIPTION = "Reach QML Viewer and init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r4"

SRCREV ="fbaef0829d5db26784d8bdf94b3534c07471eaf8" 
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
