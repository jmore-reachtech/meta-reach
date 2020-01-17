DESCRIPTION = "Reach QML medical demo"
LICENSE = "CLOSED"

SRCREV = "8c7e80891178c02492aa23695f13c0c8ed8dcd6a"
SRC_URI = "git://github.com/jmore-reachtech/viewer-medical.git"

S = "${WORKDIR}/git"

APP_DIR = "/data/app"

do_install_append () {
	install -d ${D}${APP_DIR}
	install -m 0644 ${S}/*.* ${D}${APP_DIR}

	install -d ${D}${APP_DIR}/medical
	install -m 0644 ${S}/medical/*.* ${D}${APP_DIR}/medical

	install -d ${D}${APP_DIR}/medical/Fonts
	install -m 0644 ${S}/medical/Fonts/*.* ${D}${APP_DIR}/medical/Fonts

	install -d ${D}${APP_DIR}/medical/Images
	install -m 0644 ${S}/medical/Images/*.* ${D}${APP_DIR}/medical/Images
}

FILES_${PN} += "${APP_DIR}/*"
