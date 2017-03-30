SUMMARY = "Browser demo"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRC_URI = "\
    file://browser-demo.init \
    file://browser-demo.qml \
"

S = "${WORKDIR}"

inherit allarch update-rc.d

INITSCRIPT_NAME = "browser-demo"
INITSCRIPT_PARAMS = "start 99 5 2 ."

do_install() {
    install -Dm 0755 ${WORKDIR}/browser-demo.init ${D}/${sysconfdir}/init.d/browser-demo
    install -Dm 0644 ${WORKDIR}/browser-demo.qml ${D}${datadir}/reach/browser-demo.qml
}

FILES_${PN} += "${datadir}"

RDEPENDS_${PN} += " \
    qtbase-plugins \
    qtdeclarative-tools \
"
