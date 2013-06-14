DESCRIPTION = "Reach Manufacturing and Test"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r0"

DEPENDS = "i2c-tools"

SRC_URI = "git://git@github.com/jmore-reachtech/reach-mfg-test.git;branch=master;protocol=ssh"
SRCREV = "0694f7db744b69294e90773e0cff8d2f6e44f7bf"

S = "${WORKDIR}/git"

do_compile() {
	make all
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${S}/src/mfg-test ${D}${sbindir}
}
