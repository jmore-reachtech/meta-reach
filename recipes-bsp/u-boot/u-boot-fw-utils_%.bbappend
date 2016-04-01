FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DESCRIPTION = "u-boot-fw-utils overrides for Reach Tech"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=0507cd7da8e7ad6d6701926ec9b84c95"

PV = "2015.10"

SRCREV = "817ab232032cd01d4f730f4c5e79401e6e5bdcd4"
SRC_URI = "\
    git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=reach-${PV};protocol=git \
    file://fw_env.config \
"

do_install_append() {
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}
