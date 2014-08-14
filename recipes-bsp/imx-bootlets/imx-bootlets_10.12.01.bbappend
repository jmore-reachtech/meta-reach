FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-bootlets.git \
	file://linux-fix-paths.patch \
	file://linux-fix-paths-ivt.patch \
	file://0001-Fix-MMC-boot-partition.patch \
	file://quiet-boot.patch \
        file://add-command-script-for-barebox.patch \
"

SRCREV = "6275258786111e148517a849e6129233d0199c9b"

S = "${WORKDIR}/git"

do_configure_append () {
    # Use machine specific binaries
    sed 's,@MACHINE@,${MACHINE},g;s,@DTB@,-dtb,g' < linux_ivt.bd > linux_ivt.bd-dtb
    sed -i 's,@MACHINE@,${MACHINE},g;s,@DTB@,,g' linux_ivt.bd
}

do_install_append () {
    install -m 644 linux_ivt.bd linux_ivt.bd-dtb ${D}/boot
}

do_deploy_append () {
	for f in linux_ivt.bd linux_ivt.bd-dtb; do
        full_name="imx-bootlets-`basename $f`-${MACHINE}-${PV}-${PR}"
        symlink_name="imx-bootlets-`basename $f`-${MACHINE}"

        install -m 644 ${S}/$f ${DEPLOY_DIR_IMAGE}/$full_name
        (cd ${DEPLOY_DIR_IMAGE} ; rm -f $symlink_nake ; ln -sf $full_name $symlink_name)
    done
}
