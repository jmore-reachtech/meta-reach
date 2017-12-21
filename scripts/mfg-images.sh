#!/bin/bash

# we need this in order to set /etc/reach-pn
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE REACH_PN"

clear

DEPLOY_DIR="tmp/deploy/images"
IMG_PREFIX="reach-image-mfg-"
IMG_EXT=".sdcard"

function build_mfg() {
    M=$1
    P=$2
    MACHINE=$M REACH_PN=$P bitbake reach-version -c cleansstate
    MACHINE=$M REACH_PN=$P bitbake reach-image-mfg-g2h
    cp -L ${DEPLOY_DIR}/${M}/${IMG_PREFIX}${M}${IMG_EXT} ${P}.img
    zip ${P}.img.zip ${P}.img
}

rm -rf *.img
rm -rf *.zip

# this matches the list below
IMG_COUNT=16

#         Machine name      Part number
build_mfg "g2h-solo-3"      "51-0406-211-RC2"
build_mfg "g2h-solo-3-r"    "61-0406-11-RC2"
build_mfg "g2h-solo-3f"     "51-0406-411-RC2"
build_mfg "g2h-solo-4"      "51-0406-201-RC2"
build_mfg "g2h-solo-4f"     "51-0406-401-RC2"
build_mfg "g2h-solo-6"      "999-00100-RC2"
build_mfg "g2h-solo-7f"     "61-0406-361ES1-RC2"
build_mfg "g2h-solo-11f"    "51-0406-051-RC2"
build_mfg "g2h-solo-11f-r"  "61-0406-41-RC2"
build_mfg "g2h-solo-12f"    "51-0406-042-RC2"
build_mfg "g2h-solo-13"     "51-0406-181-RC2"
build_mfg "g2h-solo-13f"    "51-0406-081-RC2"
build_mfg "g2h-solo-14"     "51-0406-191ES-RC2"
build_mfg "g2h-solo-14f"    "51-0406-091-RC2"
build_mfg "g2h-solo-18f"    "51-0406-0D2-RC2"
build_mfg "g2h-solo-19f"    "51-0406-0C1-RC2"

IMG_BUILT=$(ls -lt *.zip | wc -l)

clear

echo "=================Summary======================"
echo "Expected builds: ${IMG_COUNT}, built: ${IMG_BUILT}"
echo "=============================================="
