DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRCREV = "dab0582465231115f23e8f057e4df2919d4fcbc5"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-io-demo.git;protocol=ssh \
                   file://io-demo \
          "
          
S = "${WORKDIR}/git"
TARGET_CC_ARCH += "${LDFLAGS}"

inherit reach-application-package

do_install() {
        install -Dm 0755 ${S}/src/io-agent ${D}${APP_BIN_DESTDIR}/io-agent
        install -Dm 0755 ${WORKDIR}/io-demo ${D}${sysconfdir}/init.d/io-demo
}
