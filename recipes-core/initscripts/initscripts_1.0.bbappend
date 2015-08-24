# Append path for poky layer to modify some init scripts
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

do_install_append() {
  install -m 0755    ${WORKDIR}/lcd-kill.sh           ${D}${sysconfdir}/init.d
  update-rc.d -r ${D} lcd-kill.sh stop 20 0 1 6 .
  
  install -m 0755    ${WORKDIR}/mount-app.sh           ${D}${sysconfdir}/init.d
  update-rc.d -r ${D} mount-app.sh start 60 S  2 . stop 20 0 1 6 .
}

SRC_URI += " file://lcd-kill.sh \
	file://mount-app.sh \
"
