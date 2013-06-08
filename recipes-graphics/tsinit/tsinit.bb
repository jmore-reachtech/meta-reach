DESCRIPTION = "Initscript to manage resistive and capacitive touchscreen drivers"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING.GPL;md5=751419260aa954499f7abaabaa882bbe"

RDEPENDS_${PN} = "i2c-tools"

PR = "r1"

SRC_URI = "file://tsinit \
           file://COPYING.GPL"
S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}
    install -d ${D}${sysconfdir}/init.d
    install tsinit ${D}${sysconfdir}/init.d
}

inherit update-rc.d

INITSCRIPT_NAME = "tsinit"
INITSCRIPT_PARAMS = "defaults 05"

PACKAGE_ARCH = "${MACHINE_ARCH}"

