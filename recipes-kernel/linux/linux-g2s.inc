# Copyright (C) 2012 O.S. Systems Software LTDA.
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Linux kernel for imx platforms"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

INC_PR = "r32"

inherit kernel

# Put a local version until we have a true SRCREV to point to
LOCALVERSION ?= "+yocto"
SCMVERSION ?= "y"

SRC_URI = "file://perf-avoid-use-sysroot-headers.patch \
	file://defconfig \
"

S = "${WORKDIR}/git"

# install nedded headers for imx-test compilation
do_install_append() {
	if [ "${IMX_TEST_SUPPORT}" = "y" ]; then
		# bounds.h may be used by a module and is currently missing
		if [ -d include/generated ]; then
			cp include/generated/* $kerneldir/include/generated/
		fi

		# Host architecture object file
		rm -f $kerneldir/scripts/kconfig/kxgettext.o
	fi
}

sysroot_stage_all_append() {
	# Copy native binaries need for imx-test build onto sysroot
	mkdir -p ${SYSROOT_DESTDIR}${KERNEL_SRC_PATH}/scripts/basic \
	         ${SYSROOT_DESTDIR}${KERNEL_SRC_PATH}/scripts/mod
	cp ${S}/scripts/basic/fixdep ${SYSROOT_DESTDIR}${KERNEL_SRC_PATH}/scripts/basic
	cp ${S}/scripts/mod/modpost ${SYSROOT_DESTDIR}${KERNEL_SRC_PATH}/scripts/mod
}
