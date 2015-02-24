DESCRIPTION = "Reach Flash Installer"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r0"

SRC_URI = "file://flash_install.sh \
        file://upgrade-flash.sh \
        file://publish-flash.sh \
"

do_install() {
	install -d ${D}${sbindir}
	install -m 755 ${WORKDIR}/flash_install.sh ${D}${sbindir}
	install -m 755 ${WORKDIR}/upgrade-flash.sh ${D}${sbindir}
	install -m 755 ${WORKDIR}/publish-flash.sh ${D}${sbindir}
}
