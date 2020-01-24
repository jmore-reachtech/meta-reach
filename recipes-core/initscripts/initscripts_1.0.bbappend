FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

do_install_append () {
	update-rc.d -f -r ${D} mountnfs.sh remove
	update-rc.d -f -r ${D} umountnfs.sh remove
}
