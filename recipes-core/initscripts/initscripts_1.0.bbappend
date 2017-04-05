# Append path for poky layer to modify some init scripts
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

do_install_append() {
  install -m 0755    ${WORKDIR}/lcd-kill.sh           ${D}${sysconfdir}/init.d
  update-rc.d -r ${D} lcd-kill.sh stop 20 0 1 6 .

  install -m 0755    ${WORKDIR}/sound.sh           ${D}${sysconfdir}/init.d
  update-rc.d -r ${D} sound.sh start 38 S .
}

SRC_URI += " file://lcd-kill.sh \
    file://sound.sh \
"
