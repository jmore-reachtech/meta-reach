# Copyright (C) 2015 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-fslc.inc

PV .= "+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-3.14:"

SRCBRANCH = "reach-fslc-3.14-1.0.x-mx6"
SRCREV = "c4623a92c95518edc1e9e50b6785ab9f42d4a594"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=${SRCBRANCH} \
           file://defconfig"

COMPATIBLE_MACHINE = "(mx6)"
