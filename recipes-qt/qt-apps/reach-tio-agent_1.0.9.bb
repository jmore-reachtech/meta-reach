DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRCREV = "7ea24864aaa80f403eb1c35b0d1ca4f2e1bad93a"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-tio-agent.git;branch=master;protocol=ssh \
		   file://tio-agent \
          "
          
FILES_${PN} += "${sysconfdir}/init.d/tio-agent"

S = "${WORKDIR}/git"

CFLAGS += " -DTIO_VERSION='"${PV}"'"

do_compile() {
		cd ${S} && ${MAKE}
}

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${S}/src/tio-agent ${D}/application/bin/tio-agent

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/tio-agent ${D}${sysconfdir}/init.d/tio-agent
}

FILES_${PN} += "/application/bin"
FILES_${PN}-dbg += "/application/bin/.debug /usr/src/debug"

inherit update-rc.d

INITSCRIPT_NAME = "tio-agent"
INITSCRIPT_PARAMS = "start 99 S ."
