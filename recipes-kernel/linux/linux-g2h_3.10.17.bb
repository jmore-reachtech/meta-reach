# Copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

# SRC_URI for kernel
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=imx-3.10.17_1.0.0-next;protocol=git \
           file://defconfig \
"

SRCREV = "46c7729050d2c9fecc4fc3bbd6e87900cc7a7ae5"

LOCALVERSION = "-1.0.0-reach"

DEPENDS += "lzop-native bc-native"

COMPATIBLE_MACHINE = "(g2h)"
