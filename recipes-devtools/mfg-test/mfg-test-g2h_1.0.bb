DESCRIPTION = "Reach Manufacturing and Test"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r2"

DEPENDS = "i2c-tools"

SRC_URI = "git://github.com/jmore-reachtech/reach-mfg-test.git;branch=g2h;protocol=git \
    file://run-mfg_g2h.sh \
    file://run-calibration.sh \
    file://tone.sh \
    file://fruit_girl.bmp \
    file://beep.wav \
"

SRCREV = "ffff50adf2a164fa1473b39df3f163a2a19a3a74"

S = "${WORKDIR}/git"

do_compile() {
	make all
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${S}/src/mfg-test ${D}${sbindir}
	install -m 755 ${WORKDIR}/run-calibration.sh ${D}${sbindir}
	
    install -d ${D}/home/root
    install -m 644 ${WORKDIR}/fruit_girl.bmp ${D}/home/root/fruit_girl.bmp
    install -m 644 ${WORKDIR}/beep.wav ${D}/home/root/beep.wav
    install -m 755 ${WORKDIR}/run-mfg_g2h.sh ${D}${sbindir}/run-mfg.sh
}

FILES_${PN} = "/home/root ${sbindir}"
