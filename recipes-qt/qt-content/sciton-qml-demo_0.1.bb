DESCRIPTION = "Sciton Qml Demo"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r2"

SRC_URI = "file://src"

APP_DIR="/application/src"

do_install() {
	install -d ${D}${APP_DIR}

	cp -rf ${WORKDIR}/src/*	${D}${APP_DIR}
}

FILES_${PN} = "${APP_DIR}"
