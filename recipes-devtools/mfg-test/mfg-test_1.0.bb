DESCRIPTION = "Reach Manufacturing and Test"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r0"

DEPENDS = "i2c-tools"

SRC_URI = "git://git@github.com/jmore-reachtech/reach-mfg-test.git;branch=master;protocol=ssh \
    file://run-mfg.sh \
    file://black480x272.bmp \
    file://white480x272.bmp \
    file://blackToRGB480x272.bmp \
    file://pattern480x272.bmp \
"

SRCREV = "1ead0507616eadc0911839f4dc10b5b70f8d210f"

S = "${WORKDIR}/git"

do_compile() {
	make all
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${S}/src/mfg-test ${D}${sbindir}
	install -m 755 ${WORKDIR}/run-mfg.sh ${D}${sbindir}

	install -d ${D}/home/root
	install -m 644 ${WORKDIR}/black480x272.bmp ${D}/home/root
	install -m 644 ${WORKDIR}/white480x272.bmp ${D}/home/root
	install -m 644 ${WORKDIR}/blackToRGB480x272.bmp ${D}/home/root
	install -m 644 ${WORKDIR}/pattern480x272.bmp ${D}/home/root
}

FILES_${PN} = "/home/root ${sbindir}"
