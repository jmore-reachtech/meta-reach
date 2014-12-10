DESCRIPTION = "Reach SIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r2"

SRCREV = "d776121374a2f279ed71b33d690514d9d61df79c"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-sio-agent.git;protocol=ssh \
		   file://sio-agent \
          "
          
FILES_${PN} += "${sysconfdir}/init.d/sio-agent"

S = "${WORKDIR}/git"

CFLAGS += " -DSIO_VERSION='"${PV}"'"

# You can override SIO_TTY in machine.conf or local.conf
SIO_TTY ?= "/dev/ttySP1"

do_compile() {
		cd ${S} && ${MAKE}
}

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${S}/src/sio-agent ${D}/application/bin/sio-agent

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/sio-agent ${D}${sysconfdir}/init.d/sio-agent
	sed -i s:#SIOTTY#:${SIO_TTY}:  ${D}${sysconfdir}/init.d/sio-agent
}

FILES_${PN} += "/application/bin"
FILES_${PN}-dbg += "/application/bin/.debug /usr/src/debug"

inherit update-rc.d

INITSCRIPT_NAME = "sio-agent"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."
