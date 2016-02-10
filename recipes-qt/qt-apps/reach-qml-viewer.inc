DESCRIPTION = "Reach QML Viewer and init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r4"

SRCREV ="fbaef0829d5db26784d8bdf94b3534c07471eaf8" 
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-viewer.git;branch=master;protocol=ssh \
"

inherit update-rc.d reach-application-package

S = "${WORKDIR}/git"

do_install() {
        install -d ${D}/application
	install -Dm 0755 ${S}/qml-viewer ${D}${APP_BIN_DESTDIR}/qml-viewer
        ln -sf ${APP_BIN_DESTDIR} ${D}/application/bin
        ln -sf ${APP_SRC_DESTDIR} ${D}/application/src
}

FILES_${PN} += "${APP_BIN_DESTDIR} /home/root /application"
FILES_${PN}-dbg += "${APP_BIN_DESTDIR}/.debug /usr/src/debug"

