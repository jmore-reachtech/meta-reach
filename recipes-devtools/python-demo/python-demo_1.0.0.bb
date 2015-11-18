DESCRIPTION = "Simple python demo"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

DEPENDS = "python gtk+"

PR = "r1"

SRC_URI = "file://python-demo.py \
           file://python-demo \
"

S = "${WORKDIR}"

inherit update-rc.d reach-application-package

INITSCRIPT_NAME = "python-demo"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."

do_install_append() {
    install -Dm 0755 ${S}/python-demo.py ${D}${APP_BIN_DESTDIR}/python-demo.py
    install -Dm 0755 ${WORKDIR}/python-demo ${D}${sysconfdir}/init.d/python-demo
}

