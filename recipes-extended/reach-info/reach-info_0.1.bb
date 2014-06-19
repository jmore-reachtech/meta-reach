DESCRIPTION = "Reach php info page"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRCREV = "d2a0bc9ed47bc4061886b5af1f4ffcfcec76db1c"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-info.git;protocol=ssh"

S = "${WORKDIR}"

DEPENDS = "lighttpd"

do_install() {
  install -d ${D}/www/pages/info

  cp -rf ${WORKDIR}/git/* ${D}/www/pages/info
}

FILES_${PN} += "/www/pages/info"
