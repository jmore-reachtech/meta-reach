DESCRIPTION = "Reach application loader"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r3"

SRCREV = "fae4424d55c13ee2a7c76c4d67a7baf509449102"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-app-loader.git;protocol=ssh"

S = "${WORKDIR}/git"

S_BASE = "${WORKDIR}/git/src"
APP_DIR = "/application/src"

SRC_URI_g2c-lite = "git://git@github.com/jmore-reachtech/reach-app-loader.git;protocol=ssh \
  file://0001-remove-sdcard-upgrade-option.patch \
"

do_install() {
        install -d ${D}${APP_DIR}

        cp -rf ${S_BASE}/*   ${D}${APP_DIR}
}

FILES_${PN} = "${APP_DIR}"
