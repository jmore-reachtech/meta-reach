DESCRIPTION = "Reach SIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r1"

SRCREV = "dce8a864c93083d12d89981c11f0834548b04b8a"
SRC_URI = "git://github.com/jmore-reachtech/reach-sio-agent.git;protocol=git \
        file://sio.init \
"

S = "${WORKDIR}/git"

CFLAGS += " -DSIO_VERSION='"${PV}"'"

do_compile() {
    cd ${S} && ${MAKE}
}

do_install() {
        install -d ${D}/application/bin
	install -m 0755 ${S}/src/sio-agent ${D}/application/bin/sio-agent

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/sio.init ${D}${sysconfdir}/init.d/sio
}

FILES_${PN} += "/application/bin"
FILES_${PN} += "${sysconfdir}/init.d/sio"

inherit update-rc.d

INITSCRIPT_NAME = "sio"
INITSCRIPT_PARAMS = "start 99 S ."

INSANE_SKIP_${PN} = "ldflags"
