# Copyright (C) 2012 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Linux kernel for imx platforms"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

INC_PR = "r32"

inherit kernel

# Put a local version until we have a true SRCREV to point to
LOCALVERSION ?= "+yocto"
SCMVERSION ?= "y"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=imx-2.6.35-mx28-next;protocol=git \
                   file://defconfig \
"

S = "${WORKDIR}/git"
