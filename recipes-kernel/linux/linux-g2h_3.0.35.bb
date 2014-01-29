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

# Add imx-test support hacks
IMX_TEST_SUPPORT ?= "y"

SRC_URI = "git://git.freescale.com/imx/linux-2.6-imx.git \
           file://defconfig \
"

S = "${WORKDIR}/git"

# We need to pass it as param since kernel might support more then one
# machine, with different entry points
KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

kernel_conf_variable() {
        CONF_SED_SCRIPT="$CONF_SED_SCRIPT /CONFIG_$1[ =]/d;"
        if test "$2" = "n"
        then
                echo "# CONFIG_$1 is not set" >> ${S}/.config
        else
                echo "CONFIG_$1=$2" >> ${S}/.config
        fi
}

do_configure_prepend() {
        echo "" > ${S}/.config
        CONF_SED_SCRIPT=""

        kernel_conf_variable LOCALVERSION "\"${LOCALVERSION}\""
        kernel_conf_variable LOCALVERSION_AUTO y

        sed -e "${CONF_SED_SCRIPT}" < '${WORKDIR}/defconfig' >> '${S}/.config'

        if [ "${SCMVERSION}" = "y" ]; then
                # Add GIT revision to the local version
                head=`git rev-parse --verify --short HEAD 2> /dev/null`
                printf "%s%s" +g $head > ${S}/.scmversion
        fi
}

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

###ACTUAL BB
# adapted from linux-imx.inc, copyright (C) 2012-2013 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

include linux-g2h.inc

# Wandboard branch - based on 4.0.0 from Freescale git
SRCREV = "d35902c77a077a25e4dfedc6aac11ba49c52c586"
LOCALVERSION = "-4.0.0-wandboard"

# GPU support patches
SRC_URI += "file://drm-vivante-Add-00-sufix-in-returned-bus-Id.patch \
            file://0001-ENGR00255688-4.6.9p11.1-gpu-GPU-Kernel-driver-integr.patch \
            file://0002-ENGR00265465-gpu-Add-global-value-for-minimum-3D-clo.patch \
            file://0003-ENGR00261814-4-gpu-use-new-PU-power-on-off-interface.patch \
            file://0004-ENGR00264288-1-GPU-Integrate-4.6.9p12-release-kernel.patch \
            file://0005-ENGR00264275-GPU-Correct-suspend-resume-calling-afte.patch \
            file://0006-ENGR00265130-gpu-Correct-section-mismatch-in-gpu-ker.patch"

COMPATIBLE_MACHINE = "g2h-7-24"
