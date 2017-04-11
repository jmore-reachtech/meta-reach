DESCRIPTION = "Reach Flash Installer"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://flash_install.sh \
           file://upgrade-flash.sh \
"

do_install() {
    install -d ${D}${sbindir}
    install -m 755 ${WORKDIR}/flash_install.sh ${D}${sbindir}
    install -m 755 ${WORKDIR}/upgrade-flash.sh ${D}${sbindir}
}

do_install_prepend_g2h() {
	sed -i s/MTD_NUM=1/MTD_NUM=2/ ${WORKDIR}/upgrade-flash.sh
}
