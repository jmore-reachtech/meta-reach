FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI_append = " \
	file://netmount \
	file://mountfs.sh \
"

do_install_append () {
	# remove banner.sh rc links
	update-rc.d -f -r ${D} banner.sh remove

	# remove banner.sh script
	rm ${D}${sysconfdir}/init.d/banner.sh

	# remove mountnfs.sh and unmountnfs.sh rc links
	update-rc.d -f -r ${D} mountnfs.sh remove
	update-rc.d -f -r ${D} umountnfs.sh remove

	# remove mountnfs.sh and unmountnfs.sh scripts
	rm ${D}${sysconfdir}/init.d/mountnfs.sh
	rm ${D}${sysconfdir}/init.d/umountnfs.sh

	# replace with netmount script
	install -m 0755    ${WORKDIR}/netmount ${D}${sysconfdir}/init.d
	update-rc.d -r ${D} netmount start 50 3 4 5 . stop 25 0 1 2 6 .

	# remove mountall.sh links
	update-rc.d -f -r ${D} mountall.sh remove

	# remove mountall.sh script
	rm ${D}${sysconfdir}/init.d/mountall.sh

	# replace with mountfs.sh script
	install -m 0755    ${WORKDIR}/mountfs.sh ${D}${sysconfdir}/init.d
	update-rc.d -r ${D} mountfs.sh start 03 S .
}
