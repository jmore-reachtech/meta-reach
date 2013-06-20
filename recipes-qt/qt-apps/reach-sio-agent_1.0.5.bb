DESCRIPTION = "Reach SIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

inherit qt4e

PR = "r1"

SRCREV = "959646e39339bd4e0af0121b62ad78abcfb332da"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-sio-agent.git;protocol=ssh"

S = "${WORKDIR}/git"

CFLAGS += " -DSIO_VERSION='"${PV}"'"

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${S}/reach-sio-agent ${D}/application/bin/sio-agent
}

FILES_${PN} = "/application/bin"
FILES_${PN}-dbg = "/application/bin/.debug /usr/src/debug"

