require recipes-bsp/u-boot/u-boot.inc

DESCRIPTION = "U-Boot for Reach Technology boards"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"

PROVIDES += "u-boot"

PV = "v2016.03+git${SRCPV}"

SRCREV = "05eb6d29956f85f3a7161f5d66d1f65661ac75a8"
SRCBRANCH = "2016.03.02"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=${SRCBRANCH} \
"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

COMPATIBLE_MACHINE = "(reach)"
