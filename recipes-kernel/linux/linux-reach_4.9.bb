# Adapted from linux-imx.inc, copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc

SUMMARY = "Linux kernel for Reach Technology boards"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=${SRCBRANCH} \
        file://0001-linux-boot-logo.patch \
        file://0002-fbmem.patch \
        file://0003-imx_rd6_defconfig.patch \
        file://defconfig \
"

LOCALVERSION = "-2.0.0-ga+yocto"
SRCBRANCH = "reach-imx_4.9.11_1.0.0_ga"
SRCREV = "c781c64680949b54ddaa1a1084afeeabc585e8ae"
DEPENDS += "lzop-native bc-native"
COMPATIBLE_MACHINE = "(reach)"
