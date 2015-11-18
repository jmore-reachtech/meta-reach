DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRCREV = "6f7ad50028e381d410c227e2ff2c605b609ee395"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-tio-agent.git;protocol=ssh \
		   file://tio-agent \
          "
          
S = "${WORKDIR}/git"

inherit update-rc.d reach-application-package

INITSCRIPT_NAME = "tio-agent"
INITSCRIPT_PARAMS = "start 99 S ."

CFLAGS += " -DTIO_VERSION='"${PV}"'"

do_install() {
	install -Dm 0755 ${S}/src/tio-agent ${D}${APP_BIN_DESTDIR}/tio-agent
	install -Dm 0755 ${WORKDIR}/tio-agent ${D}${sysconfdir}/init.d/tio-agent
}
