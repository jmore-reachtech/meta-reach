PRINC := "${@int(PRINC) + 3}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-bootlets.git;protocol=ssh \
	file://linux-fix-paths.patch \
	file://linux-fix-paths-ivt.patch \
"

SRCREV = "20f438c69570deb3e16d23645d777d4a96964d7e"

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
