FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://cgroups-mount"

do_compile_prepend () {
	# use our version of cgroups mount
	rm ${S}/scripts/cgroups-mount
	cp ${WORKDIR}/cgroups-mount ${S}/scripts/cgroups-mount
}

INITSCRIPT_PARAMS = "start 15 2 3 4 5 . stop 40 0 1 6 ."

