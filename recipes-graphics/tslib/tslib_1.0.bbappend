# Copyright (C) 2011-2012 Reach Technology
# Released under the MIT license (see COPYING.MIT for the terms)

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit update-rc.d

FILES_${PN} += "${sysconfdir}/init.d/pointercal \
"

SRC_URI_append = "file://0001-Fix-for-eGalax-and-Penmount.patch \
file://pointercal \
"

do_install_append() {
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/pointercal ${D}${sysconfdir}/init.d/pointercal
}

INITSCRIPT_NAME = "pointercal"
INITSCRIPT_PARAMS = "start 56 S ."

