DESCRIPTION = "Reach php info page"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r1"

SRCREV = "f6efe2e2c198584a0bbbd4757fc9e2ea5528d3e4"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-info.git;protocol=ssh"

S = "${WORKDIR}"

DEPENDS = "lighttpd"

do_install() {
  install -d ${D}/www/pages/info

  cp -rf ${WORKDIR}/git/* ${D}/www/pages/info
}

FILES_${PN} += "/www/pages/info"
