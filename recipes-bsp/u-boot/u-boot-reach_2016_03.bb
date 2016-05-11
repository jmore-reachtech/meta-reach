require recipes-bsp/u-boot/u-boot-fslc.inc

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"

SRCREV = "ecba2df2f46152342a7a0b8bfb075caa5d0388e2"
SRCBRANCH = "2016.03+reach"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=${SRCBRANCH};protocol=git"
