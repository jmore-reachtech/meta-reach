DESCRIPTION = "Reach Qml plugins - MXS"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

inherit qt4e

PR = "r2"

SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-plugins-mxs.git;branch=master;protocol=ssh \
    file://qmldir \
"
SRCREV = "05794819b8fb2a0ae039684373ac366f97589a24" 

S = "${WORKDIR}/git"

inherit reach-application-package

do_install() {
	install -Dm 0644 ${S}/lib/libsystemplugin.so ${D}${PLUGIN_DESTDIR}/libsystemplugin.so
	install -m 0755 ${WORKDIR}/qmldir ${D}${PLUGIN_DESTDIR}
}

