DESCRIPTION = "Initscript to manage resistive and capacitive touchscreen drivers"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRC_URI = "file://x11-demo \
"
S = "${WORKDIR}"

do_install() {
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/x11-demo ${D}${sysconfdir}/init.d/x11-demo
}


inherit update-rc.d

INITSCRIPT_NAME = "x11-demo"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."
