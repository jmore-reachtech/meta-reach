DESCRIPTION = "resize data partition"
LICENSE = "CLOSED"

SRC_URI = "file://data-fs-resize.sh \
	   file://data-part-resize.sh \
"

do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/data-part-resize.sh ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/data-fs-resize.sh ${D}${sysconfdir}/init.d
}

inherit update-rc.d

INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME = "data-part-resize.sh"
INITSCRIPT_PARAMS = "start 03 S ."
