SUMMARY = "Tools for managing memory technology devices"
HOMEPAGE = "http://www.linux-mtd.infradead.org/"
SECTION = "base"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=0636e73ff0215e8d672dc4c32c317bb3 \
                    file://include/common.h;beginline=1;endline=17;md5=ba05b07912a44ea2bf81ce409380049c"

inherit autotools pkgconfig

DEPENDS = "zlib lzo e2fsprogs util-linux"

PV = "2.0.0"

SRCREV = "1bfee8660131fca7a18f68e9548a18ca6b3378a0"
SRC_URI = "git://git.infradead.org/mtd-utils.git \
           file://add-exclusion-to-mkfs-jffs2-git-2.patch \
           file://fix-armv7-neon-alignment.patch \
           file://mtd-utils-fix-corrupt-cleanmarker-with-flash_erase--j-command.patch \
           file://0001-Fix-build-with-musl.patch \
           file://010-fix-rpmatch.patch \
"

S = "${WORKDIR}/git/"

EXTRA_OECONF = "--without-jffs --without-xattr"

EXTRA_OEMAKE = "'CC=${CC}' 'RANLIB=${RANLIB}' 'AR=${AR}' 'CFLAGS=${CFLAGS} -I${S}/include' 'BUILDDIR=${S}'"

do_install () {
	oe_runmake install DESTDIR=${D} SBINDIR=${sbindir} MANDIR=${mandir} INCLUDEDIR=${includedir} LIBDIR=${libdirdir}
    
    install -d ${D}${includedir}/mtd/
    install -d ${D}${libdir}/
    install -m 0644 ${S}/include/libubi.h ${D}${includedir}/mtd/
    install -m 0644 ${S}/include/libmtd.h ${D}${includedir}/mtd/
    install -m 0644 ${S}/include/mtd/ubi-media.h ${D}${includedir}/mtd/
    oe_libinstall -a libubi ${D}${libdir}/
    oe_libinstall -a libmtd ${D}${libdir}/
    oe_libinstall -a libscan ${D}${libdir}/
}

PACKAGES =+ "${PN}-jffs2 ${PN}-ubifs ${PN}-misc lib${PN}-dev lib${PN}-staticdev"

FILES_lib${PN}-dev = "${includedir}"
FILES_lib${PN}-staticdev = "${libdir}/lib*.a"

FILES_${PN}-jffs2 = "${sbindir}/mkfs.jffs2 ${sbindir}/jffs2dump ${sbindir}/jffs2reader ${sbindir}/sumtool"
FILES_${PN}-ubifs = "${sbindir}/mkfs.ubifs ${sbindir}/ubi*"
FILES_${PN}-misc = "${sbindir}/nftl* ${sbindir}/ftl* ${sbindir}/rfd* ${sbindir}/doc* ${sbindir}/serve_image ${sbindir}/recv_image"

BBCLASSEXTEND = "native nativesdk"

PARALLEL_MAKE = ""

