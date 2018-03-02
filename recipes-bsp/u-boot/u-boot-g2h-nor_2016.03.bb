SUMMARY = "Universal Boot Loader for embedded devices"
HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI[md5sum] = "36c5e6b6e91ac4b2dc9071f06875be87"
SRC_URI[sha256sum] = "710269ce456597628b990b90d65ab335bfe4e3cd3741471c5333053b84300d25"

SRCREV = "401b589b2ca08838eb1a2ca96464923db8527e8a"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=2016.03+reach-dizzy;protocol=git \
	file://env.txt \
"
INSANE_SKIP_${PN} = "already-stripped"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit uboot-config

S = "${WORKDIR}/git"

EXTRA_OEMAKE = 'CROSS_COMPILE=${TARGET_PREFIX} CC="${TARGET_PREFIX}gcc ${TOOLCHAIN_OPTIONS}"'
EXTRA_OEMAKE += 'HOSTCC="${BUILD_CC} ${BUILD_CPPFLAGS}" \
                 HOSTLDFLAGS="-L${STAGING_BASE_LIBDIR_NATIVE} -L${STAGING_LIBDIR_NATIVE}" \
                 HOSTSTRIP=true'


# Allow setting an additional version string that will be picked up by the
# u-boot build system and appended to the u-boot version.  If the .scmversion
# file already exists it will not be overwritten.
UBOOT_LOCALVERSION ?= ""

# Some versions of u-boot use .bin and others use .img.  By default use .bin
# but enable individual recipes to change this value.
UBOOT_SUFFIX ?= "bin"
UBOOT_IMAGE ?= "u-boot-nor-${MACHINE}-${PV}-${PR}.${UBOOT_SUFFIX}"
UBOOT_BINARY ?= "u-boot.${UBOOT_SUFFIX}"
UBOOT_SYMLINK ?= "u-boot-${MACHINE}.${UBOOT_SUFFIX}"
UBOOT_MAKE_TARGET ?= "all"

# Some versions of u-boot build an SPL (Second Program Loader) image that
# should be packaged along with the u-boot binary as well as placed in the
# deploy directory.  For those versions they can set the following variables
# to allow packaging the SPL.
SPL_BINARY ?= ""
SPL_IMAGE ?= "${SPL_BINARY}-${MACHINE}-${PV}-${PR}"
SPL_SYMLINK ?= "${SPL_BINARY}-${MACHINE}"

# Additional environment variables or a script can be installed alongside
# u-boot to be used automatically on boot.  This file, typically 'uEnv.txt'
# or 'boot.scr', should be packaged along with u-boot as well as placed in the
# deploy directory.  Machine configurations needing one of these files should
# include it in the SRC_URI and set the UBOOT_ENV parameter.
UBOOT_ENV_SUFFIX ?= "txt"
UBOOT_ENV ?= ""
UBOOT_ENV_BINARY ?= "${UBOOT_ENV}.${UBOOT_ENV_SUFFIX}"
UBOOT_ENV_IMAGE ?= "${UBOOT_ENV}-${MACHINE}-${PV}-${PR}.${UBOOT_ENV_SUFFIX}"
UBOOT_ENV_SYMLINK ?= "${UBOOT_ENV}-${MACHINE}.${UBOOT_ENV_SUFFIX}"

do_configure_prepend () {
    sed -i s/devicetree.dtb/${KERNEL_DEVICETREE}/ ${WORKDIR}/env.txt
}

do_compile () {
	if [ "${@bb.utils.contains('DISTRO_FEATURES', 'ld-is-gold', 'ld-is-gold', '', d)}" = "ld-is-gold" ] ; then
		sed -i 's/$(CROSS_COMPILE)ld$/$(CROSS_COMPILE)ld.bfd/g' config.mk
	fi

	unset LDFLAGS
	unset CFLAGS
	unset CPPFLAGS

	if [ ! -e ${B}/.scmversion -a ! -e ${S}/.scmversion ]
	then
		echo ${UBOOT_LOCALVERSION} > ${B}/.scmversion
		echo ${UBOOT_LOCALVERSION} > ${S}/.scmversion
	fi

    case ${MACHINE} in
    g2h-solo-3)
	    oe_runmake g2h_solo_3_spi_nor_defconfig
    ;;
    g2h-solo-3f)
	    oe_runmake g2h_solo_3f_spi_nor_defconfig
    ;;
    g2h-solo-3-r)
	    oe_runmake g2h_solo_3_spi_nor_defconfig
    ;;
    g2h-solo-4)
	    oe_runmake g2h_solo_4_spi_nor_defconfig
    ;;
    g2h-solo-4f)
	    oe_runmake g2h_solo_4f_spi_nor_defconfig
    ;;
    g2h-solo-6)
	    oe_runmake g2h_solo_6_spi_nor_defconfig
    ;;
    g2h-solo-7f)
	    oe_runmake g2h_solo_11f_spi_nor_defconfig
    ;;
    g2h-solo-13)
	    oe_runmake g2h_solo_13_spi_nor_defconfig
    ;;
    g2h-solo-13f)
	    oe_runmake g2h_solo_13f_spi_nor_defconfig
    ;;
    g2h-solo-14)
	    oe_runmake g2h_solo_14_spi_nor_defconfig
    ;;
    g2h-solo-14f)
	    oe_runmake g2h_solo_14f_spi_nor_defconfig
    ;;
    g2h-solo-11f)
	    oe_runmake g2h_solo_11f_spi_nor_defconfig
    ;;
    g2h-solo-11f-r)
	    oe_runmake g2h_solo_11f_spi_nor_defconfig
    ;;
    g2h-solo-12f)
	    oe_runmake g2h_solo_12f_spi_nor_defconfig
    ;;
    g2h-solo-18f)
	    oe_runmake g2h_solo_11f_spi_nor_defconfig
    ;;
    g2h-solo-19f)
	    oe_runmake g2h_solo_12f_spi_nor_defconfig
    ;;
    esac

	oe_runmake ${UBOOT_MAKE_TARGET}
	
	${S}/tools/mkenvimage -s 0x2000 -o u-boot-env.bin ${WORKDIR}/env.txt
}

do_install () {
    install -d ${D}/boot
    install ${S}/${UBOOT_BINARY} ${D}/boot/${UBOOT_IMAGE}
    ln -sf ${UBOOT_IMAGE} ${D}/boot/${UBOOT_BINARY}
    
    install ${S}/u-boot-env.bin ${D}/boot/u-boot-env-nor.bin
    
    cp ${S}/u-boot-env.bin ${DEPLOY_DIR_IMAGE}/u-boot-env-nor-${DATETIME}.bin
    cd ${DEPLOY_DIR_IMAGE} && ln -sf u-boot-env-nor-${DATETIME}.bin u-boot-env-nor.bin
    
    cp ${S}/${UBOOT_BINARY} ${DEPLOY_DIR_IMAGE}/u-boot-nor-${DATETIME}.${UBOOT_SUFFIX}
    cd ${DEPLOY_DIR_IMAGE} && ln -sf u-boot-nor-${DATETIME}.${UBOOT_SUFFIX} u-boot-nor.${UBOOT_SUFFIX}
}

FILES_${PN} = "/boot ${sysconfdir}"

COMPATIBLE_MACHINE = "(g2h)"
