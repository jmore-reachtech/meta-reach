# Copyright (C) 2017 Jeff Horn <jeff.horn@reachtech.com>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Compound image for G2H "
SECTION = ""

# Note: sw-description is mandatory
SRC_URI_g2h = "file://sw-description \
           "
inherit swupdate

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

# IMAGE_DEPENDS: list of Yocto images that contains a root filesystem
# it will be ensured they are built before creating swupdate image
IMAGE_DEPENDS = "core-image-minimal"

# SWUPDATE_IMAGES: list of images that will be part of the compound image
# the list can have any binaries - images must be in the DEPLOY directory
SWUPDATE_IMAGES = " \
                core-image-minimal \
                "

# Images can have multiple formats - define which image must be
# taken to be put in the compound image
SWUPDATE_IMAGES_FSTYPES[core-image-minimal] = ".ext3"

COMPATIBLE = "g2h"
