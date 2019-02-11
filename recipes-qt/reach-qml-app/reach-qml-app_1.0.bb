DESCRIPTION = "Reach Qml App"
HOMEPAGE = "http://www.reachtech.com"
LICENSE = "CLOSED"
SECTION = "qt5/app"

inherit update-rc.d

SRC_URI = "file://main.qml \
    file://app.init \
    file://qt_logo.png \
    file://beep.wav \
"

APP_DIR = "/data/qml-app"

do_install() {
    install -d ${D}${APP_DIR}
    install -m 0755 ${WORKDIR}/main.qml ${D}${APP_DIR}
    
    install -d ${D}${APP_DIR}/images
    install -m 0755 ${WORKDIR}/qt_logo.png ${D}${APP_DIR}/images
    
    install -d ${D}${APP_DIR}/audio
    install -m 0755 ${WORKDIR}/beep.wav ${D}${APP_DIR}/audio

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/app.init ${D}${sysconfdir}/init.d/qmlapp
}

FILES_${PN} = "${APP_DIR} \ 
    ${sysconfdir}/init.d \
"

INITSCRIPT_NAME = "qmlapp"
INITSCRIPT_PARAMS = "defaults 99"
