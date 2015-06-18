# Copyright (C) 2011-2012 Reach Technology
# Released under the MIT license (see COPYING.MIT for the terms)

include reach-qml-viewer-qt5.inc

SRC_URI_append = "file://qml-viewer-qt5 \
"

FILES_${PN} += "${sysconfdir}/init.d/qml-viewer-qt5"


do_install_append() {
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/qml-viewer-qt5 ${D}${sysconfdir}/init.d/qml-viewer
	
	# touch plugin is machine configurable [Tslib, EvdevPlugin]
	sed -i s/TOUCH_PLUGIN/${QPA_TOUCH_PLUGIN}/ ${D}${sysconfdir}/init.d/qml-viewer
}

INITSCRIPT_NAME = "qml-viewer"
INITSCRIPT_PARAMS = "start 99 S ."
