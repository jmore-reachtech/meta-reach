DESCRIPTION = "Reach QML medical demo"
LICENSE = "CLOSED"

SRCREV = "44f61058624a6f85fcb5087bd1e0cc52a296a985"
SRC_URI = "git://github.com/jmore-reachtech/reach-qml-medical.git"

S = "${WORKDIR}/git"

APP_DIR = "/data/app"

do_install_append () {
	install -d ${D}${APP_DIR}
	install -m 0644 ${S}/*.qml ${D}${APP_DIR}

	install -d ${D}${APP_DIR}/audio
	install -m 0644 ${S}/audio/*.wav ${D}${APP_DIR}/audio

	install -d ${D}${APP_DIR}/images
	install -m 0644 ${S}/images/*.png ${D}${APP_DIR}/images
}

FILES_${PN} += "${APP_DIR}/*"
