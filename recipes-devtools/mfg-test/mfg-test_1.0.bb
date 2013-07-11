DESCRIPTION = "Reach Manufacturing and Test"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r0"

DEPENDS = "i2c-tools"

SRC_URI = "git://git@github.com/jmore-reachtech/reach-mfg-test.git;branch=master;protocol=ssh \
    file://run-mfg.sh \
"

SRCREV = "f946d5efe9a8faeb7dcaffb1cd0d03644a5556ae"

S = "${WORKDIR}/git"

do_compile() {
	make all
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${S}/src/mfg-test ${D}${sbindir}
	install -m 755 ${WORKDIR}/run-mfg.sh ${D}${sbindir}
}
