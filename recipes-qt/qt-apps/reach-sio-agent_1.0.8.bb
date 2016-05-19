DESCRIPTION = "Reach SIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRCREV = "d776121374a2f279ed71b33d690514d9d61df79c"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-sio-agent.git;protocol=ssh \
		   file://sio-agent \
          "
          
S = "${WORKDIR}/git"

CFLAGS += " -DSIO_VERSION='"${PV}"'"

inherit update-rc.d reach-application-package

INITSCRIPT_NAME = "sio-agent"
INITSCRIPT_PARAMS = "start 97 5 2 . stop 19 0 1 6 ."

# You can override SIO_TTY in machine.conf or local.conf
SIO_TTY ?= "/dev/ttySP1"

do_install() {
	install -Dm 0755 ${S}/src/sio-agent ${D}${APP_BIN_DESTDIR}/sio-agent

	install -Dm 0755 ${WORKDIR}/sio-agent ${D}${sysconfdir}/init.d/sio-agent
	sed -i s:#SIOTTY#:${SIO_TTY}:  ${D}${sysconfdir}/init.d/sio-agent
}

