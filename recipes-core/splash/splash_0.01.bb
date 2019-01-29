DESCRIPTION = "Splash screen customization"
LICENSE = "CLOSED"

SRC_URI = "file://splash.bmp \
"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}/boot/
    install -m 0755 ${WORKDIR}/splash.bmp ${D}/boot/
}

FILES_${PN} += "/boot/*.bmp"
