DESCRIPTION = "Reach QML Viewer"
HOMEPAGE = "http://www.reachtech.com"
LICENSE = "CLOSED"
SECTION = "qt5/app"

PR = "r1"

inherit qmake5
DEPENDS = "qtbase qtdeclarative qtserialport alsa-lib"

SRCREV ="9b3aaae698f364588dc52431269ee078d4f6c402" 
SRC_URI = "git://github.com/jmore-reachtech/reach-qml-viewer.git;branch=qt5;protocol=git \
          file://qt5.sh \
          file://app.init \
          file://settings.conf \
          file://translate.txt \
"

S = "${WORKDIR}/git"
BUILDDIR = "${WORKDIR}/build"

APP_DIR="/application/bin"
SRC_DIR="/application/src"

do_install() {
	install -d ${D}${APP_DIR}
	install -m 0755 ${BUILDDIR}/qml-viewer ${D}${APP_DIR}
    
    install -d ${D}${SRC_DIR}
    install -m 0755 ${WORKDIR}/settings.conf ${D}${SRC_DIR}
    install -m 0755 ${WORKDIR}/translate.txt ${D}${SRC_DIR}
    
    install -d ${D}${sysconfdir}/profile.d/
    install -m 0755 ${WORKDIR}/qt5.sh ${D}${sysconfdir}/profile.d/
    
    install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/app.init ${D}${sysconfdir}/init.d/qmlapp
}

FILES_${PN} = "${APP_DIR} \ 
    ${sysconfdir}/init.d \
    ${sysconfdir}/profile.d \
    ${SRC_DIR} \ 
"

INITSCRIPT_NAME = "qmlapp"
INITSCRIPT_PARAMS = "start 99 S ."

inherit update-rc.d
