DESCRIPTION = "Freescale "
SECTION = "examples"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=393a5ca445f6965873eca0259a17f833"

PR = "r0"

SRC_URI = "http://repository.timesys.com/buildsources/k/kobs-ng/kobs-ng-${PV}/kobs-ng-${PV}.tar.gz \
	file://0001-add-canby-mach.patch \
"

SRC_URI[md5sum] = "9fce401b6c90e851f0335b9ca3a649a9"
SRC_URI[sha256sum] = "ef25f5c9033500c236b1894436bddc4e20b90bc17585fbcdf9fe3bbbd9f15781"

inherit autotools pkgconfig
