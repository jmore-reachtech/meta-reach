# Copyright (C) 2011-2012 Reach Technology
# Released under the MIT license (see COPYING.MIT for the terms)
INCLUDE_DIR = "-I${STAGING_KERNEL_DIR}/include -I${WORKDIR}/${PN}-${PV}/src"
EXTRA_OEMAKE = "INCLUDES='${INCLUDE_DIR}'"

DEPENDS = "linux-libc-headers"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit update-rc.d

FILES_${PN} += "${sysconfdir}/init.d/pointercal \
"

SRC_URI_append = "file://pointercal \
"

do_install_append() {
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/pointercal ${D}${sysconfdir}/init.d/pointercal
}

INITSCRIPT_NAME = "pointercal"
INITSCRIPT_PARAMS = "start 56 S ."
