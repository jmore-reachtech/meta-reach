DESCRIPTION = "Splash screen customization"
LICENSE = "CLOSED"

RDEPENDS_${PN} = "fbida"

SRC_URI = "file://splash.bmp \
	   file://splash.sh \
"

do_install() {
    install -d ${D}/data/
    install -m 0755 ${WORKDIR}/splash.bmp ${D}/data/

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/splash.sh ${D}${sysconfdir}/init.d
}

FILES_${PN} += "/data/*.bmp"

inherit update-rc.d

INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME = "splash.sh"
INITSCRIPT_PARAMS = "start 04 S ."
