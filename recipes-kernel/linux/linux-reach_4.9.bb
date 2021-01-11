# Adapted from linux-imx.inc, copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc

SUMMARY = "Linux kernel for Reach Technology boards"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=${SRCBRANCH} \
	   file://defconfig \
"
KBUILD_DEFCONFIG = "imx_g2h_defconfig"

LOCALVERSION = "-2.0.0-ga+yocto"

SRCBRANCH = "reach-imx_4.9.x_1.0_ga"
SRCREV = "7e166c85dcc1348ef681e0a5817614c8f19fc8b8"
DEPENDS += "lzop-native bc-native"
COMPATIBLE_MACHINE = "(imx6dl-g3)"
