# Copyright (C) 2011-2012 Reach Technology
# Released under the MIT license (see COPYING.MIT for the terms)

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit update-rc.d

FILES_${PN} += "${sysconfdir}/init.d/pointercal \
    ${sysconfdir}/ts.conf.pcap \
    ${sysconfdir}/ts.conf.resistive \
"

SRC_URI_append = "file://0001-Fix-for-eGalax-and-Penmount.patch \
file://pointercal \
file://ts.conf.pcap \
file://ts.conf.resistive \
"

do_install_append() {
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/pointercal ${D}${sysconfdir}/init.d/pointercal
          install -m 0644 ${WORKDIR}/ts.conf.pcap ${D}${sysconfdir}/ts.conf.pcap
          install -m 0644 ${WORKDIR}/ts.conf.resistive ${D}${sysconfdir}/ts.conf.resistive
}

INITSCRIPT_NAME = "pointercal"
INITSCRIPT_PARAMS = "start 56 S ."

