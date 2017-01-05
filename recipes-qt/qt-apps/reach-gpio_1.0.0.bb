DESCRIPTION = "Reach GPIO init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRC_URI = "file://gpio \
"

FILES_${PN} += "${sysconfdir}/init.d/gpio"


do_install_append() {
  install -d ${D}${sysconfdir}/init.d/
  install -m 0755 ${WORKDIR}/gpio ${D}${sysconfdir}/init.d/gpio
}

INITSCRIPT_NAME = "gpio"
INITSCRIPT_PARAMS = "start 99 S ."

inherit update-rc.d
