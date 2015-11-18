DESCRIPTION = "Initscript to manage resistive and capacitive touchscreen drivers"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

DEPENDS = "gtk+"

PR = "r1"

SRC_URI = "file://main.c \
	file://gtk-demo \
"
S = "${WORKDIR}"

inherit update-rc.d reach-application-package

INITSCRIPT_NAME = "gtk-demo"
INITSCRIPT_PARAMS = "start 10 5 2 . stop 19 0 1 6 ."

do_compile() {
	${CC} `pkg-config --cflags gtk+-2.0` -o gtk2-demo main.c `pkg-config --libs gtk+-2.0`
}

do_install() {
	install -Dm 0755 ${S}/gtk2-demo ${D}${APP_BIN_DESTDIR}/gtk2-demo
	install -Dm 0755 ${WORKDIR}/gtk-demo ${D}${sysconfdir}/init.d/gtk-demo
}

