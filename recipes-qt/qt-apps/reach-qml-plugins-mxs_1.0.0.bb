DESCRIPTION = "Reach Qml plugins - MXS"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

inherit qt4e

PR = "r2"

SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-plugins-mxs.git;branch=master;protocol=ssh \
    file://qmldir \
"
SRCREV = "583ec2c2b5902b36e9efeda32083db59dcc26c1f" 

S = "${WORKDIR}/git"

PLUGIN_DIR="/application/plugins"

do_install() {
	install -d ${D}${PLUGIN_DIR}

	install -m 0755 ${S}/lib/libsystemplugin.so ${D}${PLUGIN_DIR}
	install -m 0755 ${WORKDIR}/qmldir ${D}${PLUGIN_DIR}
}

FILES_${PN} += "${PLUGIN_DIR}"
FILES_${PN}-dbg += "${PLUGIN_DIR}/.debug /usr/src/debug"

