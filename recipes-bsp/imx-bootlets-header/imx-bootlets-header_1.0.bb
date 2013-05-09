DESCRIPTION = "i.MXS Bootlets Header for HAB enabled devices"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r0"

BBCLASSEXTEND = "native"

SRC_URI = "file://mxshdr.sh"


do_install() {
	install -d ${D}${bindir}
	install ${WORKDIR}/mxshdr.sh ${D}${bindir}
}
