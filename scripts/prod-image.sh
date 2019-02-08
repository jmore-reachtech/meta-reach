#!/bin/bash

clear

DEPLOY_DIR="./tmp/deploy/images"
IMG="reach-image-qt5"
IMG_EXT=".sdimg"
IMG_EXT2=".mender"

function build_img() {
    M=$1
    P=$2

# build image
    echo MENDER_ARTIFACT_NAME=\"${P}\" > ./conf/site.conf
    MACHINE=$M bitbake ${IMG}
    rm ./conf/site.conf

# copy, rename, and compress full image
    cp -L ${DEPLOY_DIR}/${M}/${IMG}-${M}${IMG_EXT} .
    mv ${IMG}-${M}${IMG_EXT} ${IMG}-${P}${IMG_EXT}
    zip ${IMG}-${P}${IMG_EXT}.zip ${IMG}-${P}${IMG_EXT}
# copy, and rename update image
# no need to compress since it is already a .gz file
    cp -L ${DEPLOY_DIR}/${M}/${IMG}-${M}${IMG_EXT2} .
    mv ${IMG}-${M}${IMG_EXT2} ${IMG}-${P}${IMG_EXT2}

}

rm -f *.sdimg
rm -f *.sdimg.zip
rm -f *.mender

# this matches the list below
IMG_COUNT=1

#         Machine name   Release name
build_img "reach"      	"0.0.0.3"

IMG_BUILT=$(ls -lt *.zip | wc -l)

clear

echo "=================Summary======================"
echo "Expected builds: ${IMG_COUNT}, built: ${IMG_BUILT}"
echo "=============================================="

