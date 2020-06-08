FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://ntpdate.init"

do_install_append () {
    install -d ${D}${sysconfdir}/init.d
    install -m 755 ${WORKDIR}/ntpdate.init ${D}${sysconfdir}/init.d/ntpdate
}

FILES_ntpdate += "${sysconfdir}/init.d/ntpdate"

INITSCRIPT_PACKAGES = "${PN} ntpdate"

INITSCRIPT_PARAMS_${PN} = "start 40 3 4 5 . stop 65 0 1 2 6 ."

INITSCRIPT_NAME_ntpdate = "ntpdate"
INITSCRIPT_PARAMS_ntpdate = "start 35 3 4 5 . stop 65 0 1 2 6 ."

