DESCRIPTION = "Reach Qml plugins - iMX"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

inherit qmake5
DEPENDS += "qtbase qtdeclarative"

PR = "r1"

SRC_URI = "git://github.com/jmore-reachtech/reach-qml-plugins-imx.git;branch=master;protocol=git \
"
SRCREV = "40b4f7ab13c1fdf8d9886b2dbd5c4c8c84f0f017" 

S = "${WORKDIR}/git"
BUILD_DIR = "${WORKDIR}/build"

PLUGIN_DIR="/usr/lib/qt5/qml/com/reachtech/systemplugin"

do_install() {
	install -d ${D}${PLUGIN_DIR}

	install -m 0755 ${BUILD_DIR}/libsystemplugin.so ${D}${PLUGIN_DIR}
	install -m 0755 ${BUILD_DIR}/qmldir ${D}${PLUGIN_DIR}
}

FILES_${PN} += "${PLUGIN_DIR}"
FILES_${PN}-dbg += "${PLUGIN_DIR}/.debug /usr/src/debug"

