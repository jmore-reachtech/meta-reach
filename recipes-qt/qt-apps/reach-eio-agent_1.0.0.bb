DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r1"

SRCREV = "0f87cb4374ed43befae2d42bec85849ba36fcf0d"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-eio-agent.git;protocol=ssh \
		   file://eio-agent \
          "
          
FILES_${PN} += "${sysconfdir}/init.d/eio-agent"

S = "${WORKDIR}/git"

CFLAGS += " -DiEIO_VERSION='"${PV}"'"

do_compile() {
		cd ${S} && ${MAKE}
}

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${S}/src/eio-agent ${D}/application/bin/eio-agent

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/eio-agent ${D}${sysconfdir}/init.d/eio-agent
}

FILES_${PN} += "/application/bin"
FILES_${PN}-dbg += "/application/bin/.debug /usr/src/debug"
