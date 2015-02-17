# Copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

# SRC_URI for kernel
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=imx-3.10.17_1.0.0-next;protocol=git \
           file://0001-update-linux-kernel-logo.patch \
           file://defconfig \
"

SRCREV = "ab0a635b1187c22f2f99d520bfe426b80c6f16dd"

LOCALVERSION = "-1.0.0-reach"

DEPENDS += "lzop-native bc-native"

COMPATIBLE_MACHINE = "(g2h)"
