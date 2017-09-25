SUMMARY = "U-Boot bootloader fw_printenv/setenv utilities"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SECTION = "bootloader"
DEPENDS = "mtd-utils"


SRCREV = "9207512c4747410b6d74f1c2e6c2af30a36290a2"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=2016.03+reach-dizzy;protocol=git \
    file://001-libuboot-env-link-error.patch \
    file://fw_env.config \
"

S = "${WORKDIR}/git"

#EXTRA_OEMAKE = 'HOSTCC="${CC}" HOSTSTRIP="true"'
INSANE_SKIP_${PN} = "already-stripped"
EXTRA_OEMAKE = 'CROSS_COMPILE=${TARGET_PREFIX} CC="${CC} ${CFLAGS} ${LDFLAGS}" V=1'

inherit uboot-config

do_compile () {
	oe_runmake ${UBOOT_MACHINE}
	oe_runmake env
}

do_install () {
	install -d ${D}${base_sbindir}
	install -d ${D}${sysconfdir}
	install -m 755 ${S}/tools/env/fw_printenv ${D}${base_sbindir}/fw_printenv
	install -m 755 ${S}/tools/env/fw_printenv ${D}${base_sbindir}/fw_setenv
	install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config

        install -d ${D}${libdir}
        install -m 644  ${S}/tools/env/lib.a ${D}${libdir}/libubootenv.a
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

PROVIDES_${PN} = "u-boot-fw-utils"
RPROVIDES_${PN} = "u-boot-fw-utils"
