DESCRIPTION = "Simple python demo"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

DEPENDS = "python gtk+"

PR = "r1"

SRC_URI = "file://python-demo.py \
           file://python-demo \
"

S = "${WORKDIR}"

APP_DIR="/application/bin"

do_install() {
    install -d ${D}${APP_DIR}
    install -m 0755 ${S}/python-demo.py ${D}${APP_DIR}

    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/python-demo ${D}${sysconfdir}/init.d/python-demo
}

FILES_${PN} += "${APP_DIR} ${ROOT_HOME}"
FILES_${PN}-dbg += "${APP_DIR}/.debug /usr/src/debug"

inherit update-rc.d

INITSCRIPT_NAME = "python-demo"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."
