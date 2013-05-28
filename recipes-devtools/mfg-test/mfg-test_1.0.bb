DESCRIPTION = "Reach Manufacturing and Test"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r0"

DEPENDS = "i2c-tools"

SRC_URI = "file://mfg_test.c"

S = "${WORKDIR}"

do_compile() {
	${CC} mfg_test.c -o mfg_test
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 mfg_test ${D}${sbindir}
}
