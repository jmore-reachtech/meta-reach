DESCRIPTION = "Reach php info page"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r1"

SRCREV = "d2a0bc9ed47bc4061886b5af1f4ffcfcec76db1c"
SRC_URI = "git://github.com/jmore-reachtech/reach-info.git;protocol=git"

S = "${WORKDIR}"

DEPENDS = "lighttpd"

do_install() {
  install -d ${D}/www/pages/info

  cp -rf ${WORKDIR}/git/* ${D}/www/pages/info
}

FILES_${PN} += "/www/pages/info"
