# Copyright (C) 2015 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-fslc.inc

PV .= "+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-3.14:"

SRCBRANCH = "reach-fslc-3.14-1.0.x-mx6"
SRCREV = "13c0596871ccfba1711007ecddb68e6d25516f5f"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=${SRCBRANCH} \
           file://0001-update-linux-kernel-logo.patch \
           file://defconfig"

COMPATIBLE_MACHINE = "(mx6)"
