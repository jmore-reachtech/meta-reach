require recipes-bsp/u-boot/u-boot-fslc.inc

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"

SRCREV = "d15668852cf77402707e29a133d9d63d0094ef94"
SRCBRANCH = "2016.03+reach"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=${SRCBRANCH};protocol=git"
