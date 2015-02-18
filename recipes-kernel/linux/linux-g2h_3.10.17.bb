# Copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

# SRC_URI for kernel
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=reach-imx-3.10.17_1.0.2;protocol=git \
           file://0001-update-linux-kernel-logo.patch \
           file://defconfig \
"

SRCREV = "9d1c0dd99e440eac46d21e21780aefe0688b7cfe"

LOCALVERSION = "-1.0.2-reach"

DEPENDS += "lzop-native bc-native"

COMPATIBLE_MACHINE = "(g2h)"
