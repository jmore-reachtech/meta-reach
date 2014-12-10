DESCRIPTION = "Reach QML Viewer and init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

inherit qmake5
DEPENDS = "qtbase qtquick1"

SRCREV ="5615037080484c274bd53c6e4859a2b82f7aa09e" 
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-viewer.git;branch=qt5;protocol=ssh \
"

S = "${WORKDIR}/git"
BUILDDIR = "${WORKDIR}/build"

APP_DIR="/application/bin"

do_install() {
	install -d ${D}${APP_DIR}
	install -m 0755 ${BUILDDIR}/qml-viewer ${D}${APP_DIR}
}

FILES_${PN} += "${APP_DIR} /home/root"
FILES_${PN}-dbg += "${APP_DIR}/.debug /usr/src/debug"

inherit update-rc.d
