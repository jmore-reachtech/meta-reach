#!/bin/bash

# we need this in order to set /etc/reach-release
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE REACH_RELEASE"

clear

DEPLOY_DIR="./tmp/deploy/images"
IMG="sciton-image-qt5"
IMG_EXT=".wic"
IMG_COMPRESS=".gz"

function build_img() {
	M=$1
	P=$2
    MACHINE=$M REACH_RELEASE=${P} bitbake ${IMG}
    cp -L ${DEPLOY_DIR}/${M}/${IMG}-${M}${IMG_EXT}${IMG_COMPRESS} .
	gunzip -d ${IMG}-${M}${IMG_EXT}${IMG_COMPRESS}
	mv ${IMG}-${M}${IMG_EXT} ${P}.img
    zip ${P}.img.zip ${P}.img
}

rm -f *.img
rm -f *.zip

# this matches the list below
IMG_COUNT=1

#         Machine name      Part number
build_img "sciton"      	"S046-004A"

IMG_BUILT=$(ls -lt *.zip | wc -l)

clear

echo "=================Summary======================"
echo "Expected builds: ${IMG_COUNT}, built: ${IMG_BUILT}"
echo "=============================================="

