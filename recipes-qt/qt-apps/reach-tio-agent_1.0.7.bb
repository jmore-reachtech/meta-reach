DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

inherit qt4e

PR = "r2"

SRCREV = "4ee4e9adce377bb486acd17e132d7015bbdb4877"
SRC_URI = " \
           git://git@github.com/jmore-reachtech/reach-tio-agent.git;protocol=ssh \
           file://tio-agent \
          "

S = "${WORKDIR}/git"

CFLAGS += " -DTIO_VERSION='"${PV}"'"

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${S}/reach-tio-agent ${D}/application/bin/tio-agent

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/tio-agent ${D}${sysconfdir}/init.d/tio-agent
}

FILES_${PN} += "/application/bin"
FILES_${PN}-dbg += "/application/bin/.debug /usr/src/debug"

inherit update-rc.d

INITSCRIPT_NAME = "tio-agent"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."
