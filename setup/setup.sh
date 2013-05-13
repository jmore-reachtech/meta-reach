#!/bin/bash

BASE_DIR=$(pwd)

POKY_DIR=poky
POKY_URI=git://git.yoctoproject.org/poky
POKY_BRANCH=danny
POKY_REV=a69769e3b3e7f475e416d3a49d68dab088592851

FSL_DIR=meta-fsl-arm
FSL_URI=git://github.com/Freescale/meta-fsl-arm.git
FSL_BRANCH=danny
FSL_REV=a0e486a76af5819ee76ac34e966feb72bd3c48bd

pushd ../

# checkout out poky
git clone -b $POKY_BRANCH  $POKY_URI
pushd $POKY_DIR
git checkout -b $POKY_REV
popd

# checkout out meta-fsl-arm
git clone -b $FSL_BRANCH $FSL_URI
pushd $FSL_DIR
git checkout -b $FSL_REV
popd

popd
