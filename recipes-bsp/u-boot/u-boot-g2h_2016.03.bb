require recipes-bsp/u-boot/u-boot.inc

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "(g2h)"
DEPENDS_mxs += "elftosb-native openssl-native"
PROVIDES += "u-boot"

SRC_URI[md5sum] = "36c5e6b6e91ac4b2dc9071f06875be87"
SRC_URI[sha256sum] = "710269ce456597628b990b90d65ab335bfe4e3cd3741471c5333053b84300d25"

SRCREV = "b7dfa3450681fd7a64229cf12d4e711a7d46df53"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=2016.03+reach-dizzy;protocol=git \
	file://env.txt \
"

S = "${WORKDIR}/git"

EXTRA_OEMAKE += 'HOSTCC="${BUILD_CC} ${BUILD_CPPFLAGS}" \
                 HOSTLDFLAGS="-L${STAGING_BASE_LIBDIR_NATIVE} -L${STAGING_LIBDIR_NATIVE}" \
                 HOSTSTRIP=true'

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${base_sbindir}/*"

do_configure_prepend () {
    sed -i s/devicetree.dtb/${KERNEL_DEVICETREE}/ ${WORKDIR}/env.txt
}

do_compile_append () {
	${S}/tools/mkenvimage -s 0x2000 -o u-boot-env.bin ${WORKDIR}/env.txt
	${MAKE} CROSS_COMPILE=${HOST_SYS}- CC="${CC}" env
}

do_install_append () {
	cp ${S}/u-boot-env.bin ${DEPLOY_DIR_IMAGE}/u-boot-env-${DATETIME}.bin
    cd ${DEPLOY_DIR_IMAGE} && ln -sf u-boot-env-${DATETIME}.bin u-boot-env.bin
}
