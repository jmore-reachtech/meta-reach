DESCRIPTION = "Reach Manufacturing and Test"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r2"

DEPENDS = "i2c-tools"

SRC_URI = "git://git@github.com/jmore-reachtech/reach-mfg-test.git;branch=master;protocol=ssh \
    file://run-mfg.sh \
    file://run-mfg_lite.sh \
    file://run-calibration.sh \
    file://tone.sh \
    file://black480x272.bmp \
    file://white480x272.bmp \
    file://blackToRGB480x272.bmp \
    file://pattern480x272.bmp \
"

SRCREV = "3f454c7ca25e9cbab70db7be1e10908bca638ee4"

S = "${WORKDIR}/git"

do_compile() {
	make all
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${S}/src/mfg-test ${D}${sbindir}
	install -m 755 ${WORKDIR}/run-calibration.sh ${D}${sbindir}
	install -m 755 ${WORKDIR}/tone.sh ${D}${sbindir}
	
    install -d ${D}/home/root
	install -m 644 ${WORKDIR}/black480x272.bmp ${D}/home/root/black.bmp
	install -m 644 ${WORKDIR}/white480x272.bmp ${D}/home/root/white.bmp
	install -m 644 ${WORKDIR}/blackToRGB480x272.bmp ${D}/home/root/blackToRGB.bmp
	install -m 644 ${WORKDIR}/pattern480x272.bmp ${D}/home/root/pattern.bmp

    install -m 755 ${WORKDIR}/run-mfg_lite.sh ${D}${sbindir}/run-mfg.sh
}

FILES_${PN} = "/home/root ${sbindir}"
