DESCRIPTION = "Reach QML viewer application"
LICENSE = "CLOSED"

inherit update-rc.d

DEPENDS =+ "qtbase qtquickcontrols2 qtserialport alsa-lib"

SRCREV = "21b48ab97faf22e3ac6a5a250feac56adb00b0f2"
SRC_URI = "git://github.com/jmore-reachtech/reach-qml-viewer-g3.git \
	   file://qmlapp \
	   file://qml-upgrade-helper.sh \
"

S = "${WORKDIR}/git"

inherit qmake5

APP_DIR = "/data/app"

do_install_append () {
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/qmlapp ${D}${sysconfdir}/init.d/qmlapp
	install -m 0755 ${WORKDIR}/qml-upgrade-helper.sh ${D}${bindir}
}

FILES_${PN} += "${APP_DIR}/* \
                ${sysconfdir}/init.d \
"

INITSCRIPT_NAME = "qmlapp"
INITSCRIPT_PARAMS = "defaults 60"
