FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PRINC := "${@int(PRINC) + 1}"

SRC_URI_append_mxs = " \
file://startx \
"

do_install_append_mxs() {
	# we want to override startx
	install -d ${D}/${bindir}
	install -m 0755 ${WORKDIR}/startx ${D}/${bindir}
}

