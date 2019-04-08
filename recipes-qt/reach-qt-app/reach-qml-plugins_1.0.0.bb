DESCRIPTION = "Reach Qml plugins - iMX"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit qmake5
DEPENDS += "qtbase qtdeclarative"

PR = "r1"

SRC_URI = "git://github.com/jmore-reachtech/reach-qml-plugins-imx.git;branch=master;protocol=git \
"
SRCREV = "e9f21c5f58307489dc9e1eacac04a75c46b0a44e" 

S = "${WORKDIR}/git"
BUILD_DIR = "${WORKDIR}/build"

PLUGIN_DIR="/usr/lib/qt5/qml/com/reachtech/systemplugin"

do_install() {
	install -d ${D}${PLUGIN_DIR}

	install -m 0755 ${BUILD_DIR}/libsystemplugin.so ${D}${PLUGIN_DIR}
	install -m 0755 ${BUILD_DIR}/qmldir ${D}${PLUGIN_DIR}
}

FILES_${PN} += "${PLUGIN_DIR}"

