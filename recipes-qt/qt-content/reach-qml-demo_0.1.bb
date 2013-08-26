DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

inherit qt4e

PR = "r1"

SRCREV = "fe1b5c2463483a6709dd328d0e4980a00a1a46ae"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo.git;protocol=ssh"

S = "${WORKDIR}/git/reachdemoplugin"

do_install() {
	install -d ${D}/application/bin
	install -m 0755 ${WORKDIR}/git/change-app.sh ${D}/application/bin
	install -m 0744 ${WORKDIR}/git/settings.conf ${D}/application/bin

	cp -rf ${WORKDIR}/git/bunn-pcap-content      ${D}/application/bin
	cp -rf ${WORKDIR}/git/bunn-resistive-content ${D}/application/bin
	cp -rf ${WORKDIR}/git/dial-content           ${D}/application/bin
	cp -rf ${WORKDIR}/git/main-content           ${D}/application/bin
	cp -rf ${WORKDIR}/git/samegame-content       ${D}/application/bin
	cp -rf ${WORKDIR}/git/vumeter-content        ${D}/application/bin

	install -d ${D}/application/bin/main-content/plugins
	install -m 0755 ${S}/libReachDemoPlugin.so   ${D}/application/bin/main-content/plugins
}

FILES_${PN} = "/application/bin"
FILES_${PN}-dbg = "/application/bin/main-content/plugins/.debug"

