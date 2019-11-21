# Adapted from linux-imx.inc, copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require ${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', '${BPN}_virtualization.inc', '', d)}
require recipes-kernel/linux/linux-imx.inc

SUMMARY = "Linux kernel for Reach Technology boards"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=${SRCBRANCH} \
	   file://defconfig \
"

LOCALVERSION = "-2.0.0-ga+yocto"

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"
SRCBRANCH = "reach-imx_4.19.35_1.0.0"
SRCREV = "f51046a073a65617a706e2430c5b2dbc0dd6dd22"

DEPENDS += "lzop-native bc-native"
COMPATIBLE_MACHINE = "(imx6dl-g3)"
