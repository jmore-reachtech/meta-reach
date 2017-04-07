DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRCREV = "7ea24864aaa80f403eb1c35b0d1ca4f2e1bad93a"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-tio-agent.git;protocol=ssh \
		   file://tio-agent \
          "
          
S = "${WORKDIR}/git"

inherit update-rc.d reach-application-package

INITSCRIPT_NAME = "tio-agent"
INITSCRIPT_PARAMS = "start 98 5 2 . stop 19 0 1 6 ."

CFLAGS += " -DTIO_VERSION='"${PV}"'"
TARGET_CC_ARCH += "${LDFLAGS}"

do_install() {
	install -Dm 0755 ${S}/src/tio-agent ${D}${APP_BIN_DESTDIR}/tio-agent
	install -Dm 0755 ${WORKDIR}/tio-agent ${D}${sysconfdir}/init.d/tio-agent
}
