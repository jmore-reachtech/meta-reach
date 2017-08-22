DESCRIPTION = "Reach Manufacturing and Test"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r2"

DEPENDS = "i2c-tools"

SRC_URI = "git://github.com/jmore-reachtech/reach-mfg-test-2.git;branch=master;protocol=git \
    file://run-mfg.sh \
    file://run-calibration.sh \
    file://tone.sh \
    file://fruit_girl.bmp \
    file://beep.wav \
    file://splash \
    file://printk \
"
inherit update-rc.d

SRCREV = "bd2477e34c8a791340a4b9a417639076884267f9"

S = "${WORKDIR}/git"

PACKAGES =+ "${PN}-splash ${PN}-printk"

FILES_${PN} += "/usr/share/mfg-test ${sbindir}"

FILES_${PN}-splash = "${sysconfdir}/init.d/splash"
FILES_${PN}-printk = "${sysconfdir}/init.d/printk"

INITSCRIPT_PACKAGES = "${PN}-splash ${PN}-printk"

INITSCRIPT_NAME_${PN}-splash = "splash"
INITSCRIPT_PARAMS_${PN}-splash = "start 60 S ."

INITSCRIPT_NAME_${PN}-printk = "printk"
INITSCRIPT_PARAMS_${PN}-printk = "start 10 S ."

do_compile() {
    mkdir "${WORKDIR}/git/bin"
	make
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${S}/bin/mfg-test ${D}${sbindir}
	install -m 755 ${WORKDIR}/run-calibration.sh ${D}${sbindir}

    install -d ${D}/usr/share/mfg-test
    install -m 644 ${WORKDIR}/fruit_girl.bmp ${D}/usr/share/mfg-test/fruit_girl.bmp
    install -m 644 ${WORKDIR}/beep.wav ${D}/usr/share/mfg-test/beep.wav
    install -m 755 ${WORKDIR}/run-mfg.sh ${D}${sbindir}/run-mfg.sh

    install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/splash ${D}${sysconfdir}/init.d/splash
    install -m 0755 ${WORKDIR}/printk ${D}${sysconfdir}/init.d/printk
}
