DESCRIPTION = "Reach QML viewer application"
LICENSE = "CLOSED"

inherit update-rc.d

DEPENDS =+ "qtbase qtquickcontrols2 qtserialport"

SRCREV = "fb9f726a1e0040fb391821675c38adbc053dc88b"
SRC_URI = "git://github.com/jmore-reachtech/reach-qml-viewer-g3.git \
	   file://qmlapp \
"

S = "${WORKDIR}/git"

inherit qmake5

APP_DIR = "/data/app"

do_install_append () {
	install -d ${D}${APP_DIR}
	install -m 0644 ${S}/settings.conf.example ${D}${APP_DIR}/settings.conf
	install -m 0644 ${S}/translate.conf.example ${D}${APP_DIR}/translate.conf

	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/qmlapp ${D}${sysconfdir}/init.d/qmlapp
}

FILES_${PN} += "${APP_DIR}/* \
                ${sysconfdir}/init.d \
"

INITSCRIPT_NAME = "qmlapp"
INITSCRIPT_PARAMS = "defaults 60"
