# Copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

# SRC_URI for kernel
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=imx-3.10.17_1.0.0-next;protocol=git \
           file://defconfig \
"

SRCREV = "729da0bf9ba41a55077a124dc45bad227fc9e0d4"

LOCALVERSION = "-1.0.0-reach"

DEPENDS += "lzop-native bc-native"

COMPATIBLE_MACHINE = "(g2h)"
