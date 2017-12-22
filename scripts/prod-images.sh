#!/bin/bash

# we need this in order to set /etc/reach-pn
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE REACH_PN"

clear

DEPLOY_DIR="tmp/deploy/images"
IMG_PREFIX="reach-image-qt5-"
IMG_EXT=".sdcard"

function build_mfg() {
    M=$1
    P=$2
    MACHINE=$M REACH_PN=$P bitbake reach-version -c cleansstate
    # u-boot-g2h-nor does not create the deploy/images dir so build
    # the kernel first so the dir exists
    MACHINE=$M REACH_PN=$P bitbake virtual/kernel
    MACHINE=$M REACH_PN=$P bitbake u-boot-g2h-nor reach-image-qt5
    cp -L ${DEPLOY_DIR}/${M}/${IMG_PREFIX}${M}${IMG_EXT} ${P}.img
    zip ${P}.img.zip ${P}.img
}

rm -f *.img
rm -f *.zip

# this matches the list below
IMG_COUNT=16

#         Machine name      Part number
build_mfg "g2h-solo-3"      "S016-006"
build_mfg "g2h-solo-3-r"    "S054-002"
build_mfg "g2h-solo-3f"     "S058-002"
build_mfg "g2h-solo-4"      "S017-006"
build_mfg "g2h-solo-4f"     "S057-002"
build_mfg "g2h-solo-6"      "S046-003"
build_mfg "g2h-solo-7f"     "S063-002"
build_mfg "g2h-solo-11f"    "S022-006"
build_mfg "g2h-solo-11f-r"  "S061-002"
build_mfg "g2h-solo-12f"    "S023-006"
build_mfg "g2h-solo-13"     "S033-006"
build_mfg "g2h-solo-13f"    "S059-002"
build_mfg "g2h-solo-14"     "S034-006"
build_mfg "g2h-solo-14f"    "S060-002"
build_mfg "g2h-solo-18f"    "S055-003"
build_mfg "g2h-solo-19f"    "S0XX-000"

IMG_BUILT=$(ls -lt *.zip | wc -l)

clear

echo "=================Summary======================"
echo "Expected builds: ${IMG_COUNT}, built: ${IMG_BUILT}"
echo "=============================================="
