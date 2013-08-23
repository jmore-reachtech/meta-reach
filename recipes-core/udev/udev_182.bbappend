#add file to keep udev from caching the mac address
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
RRECOMMENDS_${PN} += "udev-cache"
PRINC := "${@int(PRINC) + 2}"

SRC_URI += " file://75-persistent-net-generator.rules \
  file://init \
  file://udev-cache \
"

do_install_append () {
  install -m 0644 ${WORKDIR}/75-persistent-net-generator.rules ${D}${sysconfdir}/udev/rules.d/
}
# Create the cache after checkroot has run
pkg_postinst_udev_append() {
        if test "x$D" != "x"; then
                OPT="-r $D"
        else
                OPT="-s"
        fi
        update-rc.d $OPT udev-cache start 36 S .
}
