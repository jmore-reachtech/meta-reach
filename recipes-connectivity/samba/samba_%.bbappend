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
INITSCRIPT_PARAMS = "start 98 S ."
CONFFILES = "${sysconfdir}/samba/smb.conf"
