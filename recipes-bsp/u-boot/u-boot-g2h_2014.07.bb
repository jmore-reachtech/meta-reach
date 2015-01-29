require recipes-bsp/u-boot/u-boot.inc

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "(g2h)"
DEPENDS_mxs += "elftosb-native openssl-native"
PROVIDES += "u-boot"

SRC_URI[md5sum] = "36c5e6b6e91ac4b2dc9071f06875be87"
SRC_URI[sha256sum] = "710269ce456597628b990b90d65ab335bfe4e3cd3741471c5333053b84300d25"

SRCREV = "ea838b76715bef3606d4307cee5bee60adbe94b4"

SRC_URI = "git://github.com/jmore-reachtech/reach-imx-u-boot.git;branch=reach-2014.07;protocol=git \
"

S = "${WORKDIR}/git"

EXTRA_OEMAKE += 'HOSTCC="${BUILD_CC} ${BUILD_CPPFLAGS}" \
                 HOSTLDFLAGS="-L${STAGING_BASE_LIBDIR_NATIVE} -L${STAGING_LIBDIR_NATIVE}" \
                 HOSTSTRIP=true'

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_configure_prepend () {
    sed -i s/imx6sdl-hawthorne.dtb/${KERNEL_DEVICETREE}/ include/configs/g2h_solo.h
}


