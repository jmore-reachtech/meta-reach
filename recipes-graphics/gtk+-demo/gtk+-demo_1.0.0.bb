DESCRIPTION = "Initscript to manage resistive and capacitive touchscreen drivers"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

DEPENDS_${PN} = "gtk+"

PR = "r1"

SRC_URI = "file://main.c \
	file://gtk-demo \
"
S = "${WORKDIR}"

APP_DIR="/application/bin"

do_compile() {
	${CC} `pkg-config --cflags gtk+-2.0` -o gtk2-demo main.c `pkg-config --libs gtk+-2.0`
}

do_install() {
	install -d ${D}${APP_DIR}
	install -m 0755 ${S}/gtk2-demo ${D}${APP_DIR}
	
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/gtk-demo ${D}${sysconfdir}/init.d/gtk-demo
}

FILES_${PN} += "${APP_DIR} /home/root"
FILES_${PN}-dbg += "${APP_DIR}/.debug /usr/src/debug"

inherit update-rc.d

INITSCRIPT_NAME = "gtk-demo"
INITSCRIPT_PARAMS = "start 10 5 2 . stop 19 0 1 6 ."
