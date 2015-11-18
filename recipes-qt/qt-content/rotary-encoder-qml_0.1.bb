DESCRIPTION = "Simple QML demo for the rotary plugins"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRCREV = "e83db8af93da4371293272978a8ef6db3b611381"
SRC_URI = "git://git@github.com/jmore-reachtech/rotary-encoder-qml.git;protocol=ssh \
"

S = "${WORKDIR}/git"

inherit reach-application-package

do_install() {
        install -d ${D}${APP_SRC_DESTDIR}
        cp -rf ${S}/*   ${D}${APP_SRC_DESTDIR}
}

