FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PRINC := "${@int(PRINC) + 1}"

SRC_URI += "file://X0.hosts"

do_install_append() {
	# we want to a X0.hosts sample
	install -d ${D}/${sysconfdir}
	install -m 0644 ${WORKDIR}/X0.hosts ${D}/${sysconfdir}
}
