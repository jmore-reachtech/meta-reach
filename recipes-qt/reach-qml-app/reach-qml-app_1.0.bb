DESCRIPTION = "Reach Qml App"
HOMEPAGE = "http://www.reachtech.com"
LICENSE = "CLOSED"
SECTION = "qt5/app"

SRC_URI = "file://mainview.qml \
    file://qt_logo.png \
    file://beep.wav \
"

APP_DIR = "/application/src"

do_install() {
    install -d ${D}${APP_DIR}
    install -m 0755 ${WORKDIR}/mainview.qml ${D}${APP_DIR}
    
    install -d ${D}${APP_DIR}/images
    install -m 0755 ${WORKDIR}/qt_logo.png ${D}${APP_DIR}/images
    
    install -d ${D}${APP_DIR}/audio
    install -m 0755 ${WORKDIR}/beep.wav ${D}${APP_DIR}/audio
}

FILES_${PN} = "${APP_DIR} \ 
    ${sysconfdir}/init.d \
"
