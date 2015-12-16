# Copyright (C) 2015 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-fslc.inc

PV .= "+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-3.14:"

SRCBRANCH = "reach-fslc-3.14-1.0.x-mx6"
SRCREV = "871afb915c86939fdf4cc5d62db025815e26534e"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=${SRCBRANCH} \
           file://0001-update-linux-kernel-logo.patch \
           file://defconfig"

COMPATIBLE_MACHINE = "(mx6)"
