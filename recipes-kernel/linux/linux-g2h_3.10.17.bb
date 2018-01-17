# Copyright (C) 2013, 2014 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=reach-imx_3.10.17_1.0.2_ga;protocol=git \
           file://defconfig \
"

SRCREV = "bbdf2b57ab76a5a5b3459f1785a2b3bba55e80c3"

LOCALVERSION = "-1.0.2-reach"

DEPENDS += "lzop-native bc-native"

COMPATIBLE_MACHINE = "(g2h)"

# Our device tree names do not match the machine names, create a symlink so swupdate can find
# the device tree
do_deploy_append() {
    bbnote "Create device tree symlink"
    cd ${DEPLOYDIR} && ln -sf ${KERNEL_IMAGETYPE}-${KERNEL_DEVICETREE} ${KERNEL_IMAGETYPE}-${MACHINE}.dtb
}
