DESCRIPTION = "Reach fbimage"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

inherit qmake5
DEPENDS = "qtbase"

SRCREV ="7af4e31750d4b13da30adaea88baa5bb530d3479" 
SRC_URI = "git://github.com/jmore-reachtech/fb2image.git;protocol=git"

S = "${WORKDIR}/git"
BUILDDIR = "${WORKDIR}/build"

APP_DIR="/application/bin"

do_install() {
	install -d ${D}${APP_DIR}
	install -m 0755 ${BUILDDIR}/fb2image ${D}${APP_DIR}
}

FILES_${PN} += "${APP_DIR} /home/root"
FILES_${PN}-dbg += "${APP_DIR}/.debug /usr/src/debug"
