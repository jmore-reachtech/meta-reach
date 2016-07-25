DESCRIPTION = "Reach QML Viewer and init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

inherit qmake5
DEPENDS = "qtbase qtquick1 qtserialport"

SRCREV = "7d49a4483a560de837e42fb28bd6439914113292"
SRC_URI = "git://github.com/jmore-reachtech/reach-qml-viewer-v2.git;branch=master \
          file://qml-viewer.sh \
"

inherit update-rc.d reach-application-package

S = "${WORKDIR}/git"
BUILDDIR = "${WORKDIR}/build"

do_install() {
    install -d ${D}/application
    install -Dm 0755 ${BUILDDIR}/qml-viewer ${D}${APP_BIN_DESTDIR}/qml-viewer
    install -Dm 0755 ${WORKDIR}/qml-viewer.sh ${D}${sysconfdir}/profile.d/qml-viewer.sh
    ln -sf ${APP_BIN_DESTDIR} ${D}/application/bin
    ln -sf ${APP_SRC_DESTDIR} ${D}/application/src
}

FILES_${PN} += "${APP_BIN_DESTDIR} /home/root /application"
FILES_${PN}-dbg += "${APP_BIN_DESTDIR}/.debug /usr/src/debug"

