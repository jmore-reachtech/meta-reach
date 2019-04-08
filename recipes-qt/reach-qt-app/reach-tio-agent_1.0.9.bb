DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r1"

SRCREV = "7ea24864aaa80f403eb1c35b0d1ca4f2e1bad93a"
SRC_URI = "git://github.com/jmore-reachtech/reach-tio-agent.git;branch=master;protocol=git \
        file://tio.init \
"
          

S = "${WORKDIR}/git"

CFLAGS += " -DTIO_VERSION='"${PV}"'"

do_compile() {
    cd ${S} && ${MAKE}
}

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${S}/src/tio-agent ${D}/application/bin/tio-agent

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/tio.init ${D}${sysconfdir}/init.d/tio
}

FILES_${PN} += "/application/bin"
FILES_${PN} += "${sysconfdir}/init.d/tio-agent"

inherit update-rc.d

INITSCRIPT_NAME = "tio"
INITSCRIPT_PARAMS = "start 99 S ."

INSANE_SKIP_${PN} = "ldflags"
