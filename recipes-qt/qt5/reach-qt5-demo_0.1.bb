DESCRIPTION = "Reach qml-viewer demo content"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

##
# Wildlife.m4v must be included in /application
# That file is located on A drive in /Developers
##
PR = "r1"

DEPENDS = "qtdeclarative qtgraphicaleffects"
RDEPENDS_${PN} = "qtdeclarative-qmlplugins qtgraphicaleffects-qmlplugins"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = "\
        file://mainview.qml \
        file://shfldemoinit \
"
APP_DIR = "/application/src"

do_install_append() {
  install -d ${D}${APP_DIR}
  install -d ${D}${sysconfdir}
  install -d ${D}${sysconfdir}/init.d
  cp ${WORKDIR}/shfldemoinit ${D}${sysconfdir}/init.d
  cp ${WORKDIR}/mainview.qml ${D}${APP_DIR}
}

inherit update-rc.d

INITSCRIPT_NAME = "shfldemoinit"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."

FILES_${PN} = " shfldemoinit mainview.qml ${APP_DIR} ${sysconfdir}/init.d "
