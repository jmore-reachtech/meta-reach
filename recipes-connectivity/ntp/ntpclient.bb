DESCRIPTION = "ntpclient"
SECTION = "iotproduct"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://README;md5=098a6a289094e42f974b11e2151f5644"
PR = "r0"
PV = "2010_365"


SRC_URI = "http://doolittle.icarus.com/ntpclient/ntpclient_${PV}.tar.gz \
           file://Makefile"
SRC_URI[md5sum] = "a64689398f2df8933ee0d8da246e9eaa"
SRC_URI[sha256sum] = "9ad9b028385082fb804167f464e2db0a0b3d33780acd399327e64898b8fcfddd"

S = "${WORKDIR}/${PN}-2010"

do_patch () {
        cp -f ${WORKDIR}/Makefile ${S}/
}

do_compile () {
        oe_runmake
}

do_install () {
        install -d ${D}/${sbindir}
        install -m 0755 ${S}/ntpclient ${D}/${sbindir}
}
