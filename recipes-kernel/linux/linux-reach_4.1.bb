# Copyright (C) 2015, 2016 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-fslc.inc

PV .= "+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-4.1:"

SRCBRANCH = "4.1.x+reach"
SRCREV = "48f77bedc01bbc1cb5f2097ca6af1a16f325be22"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=${SRCBRANCH} \
           file://0001-update-linux-kernel-logo.patch \
           file://defconfig"

COMPATIBLE_MACHINE = "(mxs)"
