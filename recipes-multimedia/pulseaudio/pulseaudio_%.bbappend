FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://client.conf \
	file://system.pa \
	file://pulseaudio.sh \
"

do_compile_append () {
	mv ${WORKDIR}/build/src/client.conf ${WORKDIR}/build/src/client.conf.orig
	cp ${WORKDIR}/client.conf ${WORKDIR}/build/src/

	mv ${WORKDIR}/build/src/system.pa ${WORKDIR}/build/src/system.pa.orig
	cp ${WORKDIR}/system.pa ${WORKDIR}/build/src/
}

do_install_append () {
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/pulseaudio.sh ${D}${sysconfdir}/init.d/
}

inherit update-rc.d

INITSCRIPT_PACKAGES = "${PN}-server"
INITSCRIPT_NAME = "pulseaudio.sh"
INITSCRIPT_PARAMS = "start 30 3 4 5 . stop 30 0 1 2 6 ."

FILES_${PN}-server += " \
	${sysconfdir}/init.d \
"
