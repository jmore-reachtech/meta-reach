DESCRIPTION = "ifplugd action file and init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

SRC_URI = "file://ifplugd.init \
           file://ifplugd.action \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/ifplugd.init ${D}${sysconfdir}/init.d/ifplugd
    install -m 0755 ${WORKDIR}/ifplugd.action ${D}${sysconfdir}/ifplugd.action
}

FILES_${PN} += "${APP_DIR} ${ROOT_HOME}"

inherit update-rc.d

INITSCRIPT_NAME = "ifplugd"
INITSCRIPT_PARAMS = "start 29 5 2 ."
