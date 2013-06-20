DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

inherit qt4e

PR = "r1"

SRCREV = "4ee4e9adce377bb486acd17e132d7015bbdb4877"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-tio-agent.git;protocol=ssh"

S = "${WORKDIR}/git"

CFLAGS += " -DTIO_VERSION='"${PV}"'"

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${S}/reach-tio-agent ${D}/application/bin/tio-agent
}

FILES_${PN} = "/application/bin"
FILES_${PN}-dbg = "/application/bin/.debug /usr/src/debug"

