FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PRINC := "${@int(PRINC) + 1}"

SRC_URI_append_g2c = "file://startx \"

do_install_append_g2c() {
	# we want to override startx
	install -d ${D}/${bindir}
	install -m 0755 ${WORKDIR}/startx ${D}/${bindir}
}

