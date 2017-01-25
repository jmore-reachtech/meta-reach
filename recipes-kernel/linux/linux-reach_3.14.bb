# Copyright (C) 2015 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-fslc.inc

PV .= "+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-3.14:"

SRCBRANCH = "reach-fslc-3.14-1.0.x-mx6"
SRCREV = "d8e032b29ca24c3ccb69f6fe27aff9c8f2ce0d87"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=${SRCBRANCH} \
           file://defconfig"

COMPATIBLE_MACHINE = "(mx6)"
