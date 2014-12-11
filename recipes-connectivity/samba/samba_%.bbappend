FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGES =+ "samba-lite"

FILES_samba-lite = "${sbindir}/* \
              ${sysconfdir}/init.d/* \
              ${sysconfdir}/default/* \
              ${sysconfdir}/samba/* \
"
inherit update-rc.d

INITSCRIPT_PACKAGES += " samba-lite "
INITSCRIPT_NAME_samba-lite = "samba"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 19 0 1 6 ."
CONFFILES = "${sysconfdir}/samba/smb.conf"
