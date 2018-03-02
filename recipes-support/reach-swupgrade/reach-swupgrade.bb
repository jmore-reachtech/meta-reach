DESCRIPTION = "Reach Software Upgrade"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

DEPENDS = "libconfig"

PR = "1.0.0"

SRCREV = "e163ef5cb034e7cbce0a27a3fcac4f439765ceda"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-swupgrade.git;branch=master;protocol=ssh \
"

inherit autotools pkgconfig

S = "${WORKDIR}/git"
