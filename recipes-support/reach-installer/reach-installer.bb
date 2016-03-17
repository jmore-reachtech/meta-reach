SUMMARY = "Reach system installer (to NAND)"

SRC_URI = "file://reach-installer"

LICENSE = "CLOSED"

S = "${WORKDIR}/${PN}-${PV}"

inherit update-rc.d

INITSCRIPT_NAME = "reach-installer"
INITSCRIPT_PARAMS = "start 20 2 3 4 5 ."

do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -m 755 ${WORKDIR}/reach-installer ${D}${sysconfdir}/init.d/
}

RDEPENDS_${PN} += "\
    mtd-utils \
    mtd-utils-ubifs \
"
