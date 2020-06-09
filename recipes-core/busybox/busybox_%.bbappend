FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGES =+ "${PN}-ifplugd"
RDEPENDS_${PN}-ifplugd = "busybox bash"

SRC_URI += " \
	file://ifplugd \
	file://ifplugd.action \
	file://ifplugd.conf \
"

do_install_append() {
	if grep -q "CONFIG_IFPLUGD=y" ${B}/.config; then
		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${WORKDIR}/ifplugd ${D}${sysconfdir}/init.d/ifplugd

		install -d ${D}${sysconfdir}/ifplugd
		install -m 755 ${WORKDIR}/ifplugd.action ${D}${sysconfdir}/ifplugd/ifplugd.action
		install -m 644 ${WORKDIR}/ifplugd.conf ${D}${sysconfdir}/ifplugd/ifplugd.conf
	fi
}

FILES_${PN}-ifplugd = " \
		${sysconfdir}/init.d/ifplugd \
		${sysconfdir}/ifplugd/ifplugd.action \
		${sysconfdir}/ifplugd/ifplugd.conf \
"

INITSCRIPT_PACKAGES += "${PN}-ifplugd"

INITSCRIPT_PARAMS_${PN}-syslog = "start 20 3 4 5 . stop 60 0 1 2 6 ."
INITSCRIPT_PARAMS_${PN}-hwclock = "stop 85 0 6 ."

INITSCRIPT_NAME_${PN}-ifplugd = "ifplugd"
INITSCRIPT_PARAMS_${PN}-ifplugd = "start 30 3 4 5 . stop 80 0 1 2 6 ."


