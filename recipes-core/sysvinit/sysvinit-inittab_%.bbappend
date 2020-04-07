do_install_append () {
	sed -e s/vt102/xterm/ -i ${D}${sysconfdir}/inittab
}
