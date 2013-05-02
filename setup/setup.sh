#!/bin/bash

BASE_DIR=$(pwd)

POKY_DIR=poky
POKY_URI=git://git.yoctoproject.org/poky
POKY_REV=danny

FSL_DIR=meta-fsl-arm
FSL_URI=git://github.com/Freescale/meta-fsl-arm.git
FSL_REV=danny

OE_DIR=meta-openembedded
OE_URI=git://git.openembedded.org/meta-openembedded
OE_REV=danny

pushd ../

# checkout out poky
git clone -b $POKY_REV  $POKY_URI

# checkout out meta-fsl-arm
git clone -b $FSL_REV $FSL_URI

# checkout out meta-oe
git clone -b $OE_REV $OE_URI

popd
