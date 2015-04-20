SUMMARY = "reach file overlays"

DESCRIPTION = "reach-overlay provides the basic system startup initialization scripts for the system."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "1"

do_install() {
  install -d ${D}${sysconfdir}/init.d
  install -d ${D}${sysconfdir}/network
  install -m 0755    ${WORKDIR}/rcS-qt                ${D}${sysconfdir}/init.d/rcS
  install -m 0644    ${WORKDIR}/inittab               ${D}${sysconfdir}
  install -m 0644    ${WORKDIR}/interfaces            ${D}${sysconfdir}/network/
}

SRC_URI = "\
            file://inittab \
            file://rcS-qt \
            file://interfaces \
"
