# Copyright (C) 2011-2012 Freescale Semiconductor
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc

SRCREV = "ea6615758dfd7d1ea0b9646424f9051efaa7173c"
LOCALVERSION = "-11.09.01"

SRC_URI = "\
    git://github.com/jmore-reachtech/reach-imx-linux.git;branch=imx-2.6.35-mx53-master;protocol=git \
    file://perf-avoid-use-sysroot-headers.patch \
    file://defconfig \
"

COMPATIBLE_MACHINE = "(g2s)"
