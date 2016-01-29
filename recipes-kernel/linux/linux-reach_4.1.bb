# Copyright (C) 2015, 2016 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-fslc.inc

PV .= "+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-4.1:"

SRCBRANCH = "4.1.x+reach"
SRCREV = "f4656d40e3d8c2022e9a838f3c00be7b47185b99"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=${SRCBRANCH} \
           file://0001-update-linux-kernel-logo.patch \
           file://defconfig"

COMPATIBLE_MACHINE = "(mxs)"
