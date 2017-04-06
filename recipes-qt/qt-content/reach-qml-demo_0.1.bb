DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRCREV = "debe1dc59841f1b6faeab5012f8615d87e666752"
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
