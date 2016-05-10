do_install_append() {
    rm ${D}${sysconfdir}/init.d/banner.sh
    update-rc.d -r ${D} banner.sh remove
}
