require recipes-bsp/u-boot/u-boot.inc

DESCRIPTION = "U-Boot for Reach Technology boards"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"
DEPENDS = "bison-native"

PROVIDES += "u-boot"

PV = "v2019.01+git${SRCPV}"

SRCREV = "2ce321142a1b05dea500507efa6b720ad91c3153"
SRCBRANCH = "2019.01+reach-thud"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=${SRCBRANCH} \
"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

COMPATIBLE_MACHINE = "(reach)"
