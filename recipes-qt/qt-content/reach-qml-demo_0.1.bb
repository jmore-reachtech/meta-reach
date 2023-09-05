DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r3"

SRCREV = "f6867de5ad776d3b8f00aea105f6e12898d52135"
SRC_URI = "git://github.com/jmore-reachtech/reach-qml-demo.git;protocol=ssh"

S_BASE = "${WORKDIR}/git/src"
APP_DIR = "/application/src"

do_install() {
        install -d ${D}${APP_DIR}

        cp -rf ${S_BASE}`echo "${MACHINE}" | cut -c4-`/*   ${D}${APP_DIR}
}

FILES_${PN} = "${APP_DIR}"

