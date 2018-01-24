DESCRIPTION = "Reach Software Update Installer"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://swupdate_installer.sh \
"

do_install() {
    install -d ${D}${sbindir}
    install -m 755 ${WORKDIR}/swupdate_installer.sh ${D}${sbindir}
}
