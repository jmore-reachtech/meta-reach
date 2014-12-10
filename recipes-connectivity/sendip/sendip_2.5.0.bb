DESCRIPTION = "sendip"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r1"


SRCREV = "aaf0bd6028e8788036a89595ea2c69ebf3ce9f3f"
SRC_URI = "git://git@github.com/jmore-reachtech/sendip.git;protocol=ssh \
          "
          
S = "${WORKDIR}/git"

do_compile() {
		cd ${S} && ${MAKE}
}

do_install() {
	install -d ${D}/usr/bin
        install -d ${D}/usr/local/lib/sendip
	install -m 0755 ${S}/sendip ${D}/usr/bin/sendip
        cp ${S}/*.so ${D}/usr/local/lib/sendip
}

FILES_${PN} += "/application/bin /usr/local/lib/sendip /usr/bin"
FILES_${PN}-dbg += "/application/bin/.debug /usr/src/debug /usr/local/lib/sendip/.debug"
