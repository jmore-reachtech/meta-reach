# Copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

# SRC_URI for kernel
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=reach-imx_3.10.17_1.0.2_ga;protocol=git \
           file://0001-update-linux-kernel-logo.patch \
           file://0001-Fix-sound-enable.patch \
           file://defconfig \
"

SRCREV = "7e8d8d3f40fce3438bb1419aa01f4c7effffe520"

LOCALVERSION = "-1.0.2-reach"

DEPENDS += "lzop-native bc-native"

COMPATIBLE_MACHINE = "(g2h)"
