SUMMARY = "C/C++ Configuration File Library"
DESCRIPTION = "Library for manipulating structured configuration files"
HOMEPAGE = "http://www.hyperrealm.com/libconfig/"
SECTION = "libs"

LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING.LIB;md5=fad9b3332be894bab9bc501572864b29"

SRCREV = "1065e7e9f2977da90168b0f0de361410d786234e"

SRC_URI = "git://github.com/hyperrealm/libconfig.git;protocol=git"

S = "${WORKDIR}/git"

inherit autotools pkgconfig

