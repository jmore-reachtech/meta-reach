# Copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

# SRC_URI for kernel
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=reach-imx_3.10.17_1.0.2_ga;protocol=git \
           file://defconfig \
"

SRCREV = "f7e1bce9cca88ebc2fb8fa1c1ac3bde22eed0918"

LOCALVERSION = "-1.0.2-reach"

DEPENDS += "lzop-native bc-native"

COMPATIBLE_MACHINE = "(g2h)"
