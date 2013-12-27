DESCRIPTION = "i.MX Register tool"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r1"

SRC_URI = "file://devregs.cpp \
		file://devregs.dat \
"

S = "${WORKDIR}"

do_compile() {
	${CXX} -o devregs devregs.cpp
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${S}/devregs ${D}${sbindir}
	
	install -d ${D}${sysconfdir}
	install -m 0755 ${WORKDIR}/devregs.dat ${D}${sysconfdir}
}

