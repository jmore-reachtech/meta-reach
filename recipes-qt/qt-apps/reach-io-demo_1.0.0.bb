DESCRIPTION = "Reach TIO agent"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r1"

SRCREV = "dab0582465231115f23e8f057e4df2919d4fcbc5"
SRC_URI = "git://github.com/jmore-reachtech/reach-io-demo.git;protocol=ssh \
                   file://io-demo \
          "
          
FILES_${PN} += "${sysconfdir}/init.d/io-demo"

S = "${WORKDIR}/git"

do_compile() {
                cd ${S} && ${MAKE}
}

do_install() {
        install -d ${D}/application/bin
        install -m 0755 ${S}/src/io-agent ${D}/application/bin/io-agent

        install -d ${D}${sysconfdir}/init.d/
        install -m 0755 ${WORKDIR}/io-demo ${D}${sysconfdir}/init.d/io-demo
}

FILES_${PN} += "/application/bin"
FILES_${PN}-dbg += "/application/bin/.debug /usr/src/debug"
