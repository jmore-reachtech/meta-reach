# Copyright (C) 2011-2012 Freescale Semiconductor
# Copyright (C) 2014 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "Linux Kernel for Reach Tech platforms"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

PR = "r32.23"

require recipes-kernel/linux/linux-imx.inc

SRCBRANCH = "imx-2.6.35-mx28-master"
SRCREV = "4694fcf37f98ff6b3ee66d7d4167d4838f25cab6"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;protocol=git;branch=${SRCBRANCH} \
           file://0001-update-linux-kernel-logo.patch \
           file://0003-ARM-7668-1-fix-memset-related-crashes-caused-by-rece.patch \
           file://0004-ARM-7670-1-fix-the-memset-fix.patch \
           file://defconfig"

LOCALVERSION = "-10.12.01+reach"

S = "${WORKDIR}/git"

inherit kernel

COMPATIBLE_MACHINE = "(g2c)"
