DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRCREV = "43096be656620dce54fe39c974899620c0c92bab"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-eio-agent.git;protocol=ssh \
		   file://eio-agent \
          "
          
S = "${WORKDIR}/git"

inherit reach-application-package

CFLAGS += " -DiEIO_VERSION='"${PV}"'"

do_install() {
	install -Dm 0755 ${S}/src/eio-agent ${D}${APP_BIN_DESTDIR}/eio-agent
	install -Dm 0755 ${WORKDIR}/eio-agent ${D}${sysconfdir}/init.d/eio-agent
}
