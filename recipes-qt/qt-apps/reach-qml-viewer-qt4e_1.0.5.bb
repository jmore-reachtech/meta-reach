# Copyright (C) 2011-2012 Reach Technology
# Released under the MIT license (see COPYING.MIT for the terms)

include reach-qml-viewer.inc

inherit qt4e

SRC_URI_append = "file://qml-viewer-qt4e \
"

FILES_${PN} += "${sysconfdir}/init.d/qml-viewer-qt4e"


do_install_append() {
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/qml-viewer-qt4e ${D}${sysconfdir}/init.d/qml-viewer
}

INITSCRIPT_NAME = "qml-viewer"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."
