require u-boot.inc
require recipes-bsp/u-boot/u-boot-mender.inc

DESCRIPTION = "U-Boot for Reach Technology boards"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"
DEPENDS = "bison-native"

PROVIDES += "u-boot"
RPROVIDES_${PN} += "u-boot"

PV = "v2019.01+git${SRCPV}"

SRCREV = "42bfad11331720cbab3b7f35c5cfb41bb266356a"
SRCBRANCH = "2019.01+reach-warrior"
SRC_URI = "git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=${SRCBRANCH} \
"

SRC_URI_remove = "file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

COMPATIBLE_MACHINE = "(imx6dl-g3)"

BOOTENV_SIZE = "8192"
