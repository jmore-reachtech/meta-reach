# Copyright (C) 2017 Jeff Horn <jeff.horn@reachtech.com>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Software Update Image for G2H "
SECTION = ""

inherit swupdate

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

# IMAGE_DEPENDS: list of Yocto images that contains a root filesystem
IMAGE_DEPENDS = "reach-image-qt5"

SWUPDATE_MTDS = " \
                mtd.0.ubifs \
                mtd.1.bin \
                mtd.2.bin \
                "

SWUPDATE_MMCS = " \
                mmc.0.ext3 \
                mmc.1.bin \
                mmc.2.bin \
                "

SWUPDATE_IMAGES_MTD[mtd.0.ubifs] = "reach-image-qt5-${MACHINE}.ubifs"
SWUPDATE_IMAGES_MTD[mtd.1.bin] = "zImage-${MACHINE}.bin"
SWUPDATE_IMAGES_MTD[mtd.2.bin] = "zImage-${MACHINE}.dtb"

SWUPDATE_IMAGES_MMC[mmc.0.ext3] = "reach-image-qt5-${MACHINE}.ext3"
SWUPDATE_IMAGES_MMC[mmc.1.bin] = "zImage-${MACHINE}.bin"
SWUPDATE_IMAGES_MMC[mmc.2.bin] = "zImage-${MACHINE}.dtb"

COMPATIBLE = "g2h"
