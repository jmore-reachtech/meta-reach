DESCRIPTION = "Reach G2 Link support"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRC_URI = "file://g2link_update_services.sh"

S = "${WORKDIR}"

do_install() {
  install -d ${D}/usr/sbin

  install -m 755 ${WORKDIR}/g2link_update_services.sh ${D}/usr/sbin/g2link_update_services.sh
}

