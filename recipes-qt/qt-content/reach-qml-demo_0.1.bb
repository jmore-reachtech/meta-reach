DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r3"

SRCREV = "f6867de5ad776d3b8f00aea105f6e12898d52135"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo.git;protocol=ssh"

inherit reach-application-package

S = "${WORKDIR}/git"

DEMO_SRC = "Invalid"
DEMO_SRC_g2c-4_3-inch      = "src-43-24"
DEMO_SRC_g2c-4_3-inch-lite = "src-43-24"

do_install() {
        install -d ${D}${APP_SRC_DESTDIR}

        cp -rf ${DEMO_SRC}/*   ${D}${APP_SRC_DESTDIR}
}
