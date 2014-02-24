##
# Wildlife.m4v must be included in /usr/share/cinematicexperience
# That file is located on A drive in /Developers
#
##
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
PRINC = "1"

SRC_URI += "\
        file://Qt5_CinematicExperience.qml \
        file://shfldemoinit \
"

do_install_append() {
  install -d ${D}${sysconfdir}
  install -d ${D}${sysconfdir}/init.d
  cp ${WORKDIR}/shfldemoinit ${D}${sysconfdir}/init.d
  cp ${WORKDIR}/Qt5_CinematicExperience.qml ${D}${datadir}/${P}
}

inherit update-rc.d

INITSCRIPT_NAME = "shfldemoinit"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."

FILES_${PN} += " shfldemoinit Qt5_CinematicExperience.qml "
