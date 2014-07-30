LICENSE = "Open Market"
DESCRIPTION = "Fast CGI backend (web server to CGI handler) library"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r4"

SRC_URI = "git://git@github.com/jmore-reachtech/fastcgi.git;branch=master;protocol=ssh \
	file://cstdio.patch \
"

SRCREV = "8fb72a6c9f94aa199513938d01e1f7844749ae64"

S = "${WORKDIR}/git"

LEAD_SONAME = "libfcgi.so*"

PARALLEL_MAKE=""

inherit autotools pkgconfig


