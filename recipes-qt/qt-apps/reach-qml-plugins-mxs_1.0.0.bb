DESCRIPTION = "Reach Qml plugins - MXS"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

inherit qt4e

PR = "r1"

SRCREV ="9c5b5b7d1fb6cbbc871ae4370b16cbc43cdd00b0" 
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-plugins-mxs.git;branch=master;protocol=ssh \
    file://qmldir \
"

S = "${WORKDIR}/git"

PLUGIN_DIR="/application/plugins"
SRC_DIR="/application/src"

do_install() {
	install -d ${D}${PLUGIN_DIR}
	install -m 0755 ${S}/lib/libsystemplugin.so ${D}${PLUGIN_DIR}
	
    install -d ${D}${SRC_DIR}
	install -m 0755 ${WORKDIR}/qmldir ${D}${SRC_DIR}
}

FILES_${PN} += "${PLUGIN_DIR} ${SRC_DIR}"
FILES_${PN}-dbg += "${PLUGIN_DIR}/.debug /usr/src/debug"

