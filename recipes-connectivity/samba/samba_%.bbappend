FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://smb.conf \
            file://init.samba \
"

do_install_append() {
  install -m644 ${WORKDIR}/smb.conf ${D}${sysconfdir}/samba/smb.conf
  install -m644 ${WORKDIR}/init.samba ${D}${sysconfdir}/init.d/samba.sh
}
