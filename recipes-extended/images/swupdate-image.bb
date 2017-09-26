SUMMARY = "Root filesystem for swuupdate as rescue system"
DESCRIPTION = "Root FS to start swupdate in rescue mode"

DEPENDS = "u-boot-g2h-nor"

IMAGE_INSTALL = "base-files \
		base-passwd \
		busybox \
		mtd-utils \
		mtd-utils-ubifs \
		libconfig \
		swupdate \
        ${@bb.utils.contains('SWUPDATE_INIT', 'tiny', 'initscripts-swupdate', 'initscripts sysvinit', d)} \
		util-linux-sfdisk \
		u-boot-fw-utils \
		lua \
"

USE_DEVFS = "1"

LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420 \
		   "

# This variable is triggered to check if sysvinit must be overwritten by a single rcS
export SYSVINIT = "no"

LICENSE = "MIT"

IMAGE_FSTYPES = "ext3.gz"

IMAGE_ROOTFS_SIZE = "8192"

inherit image

remove_locale_data_files() {
	printf "Post processing local %s\n" ${IMAGE_ROOTFS}${libdir}/locale
	rm -rf ${IMAGE_ROOTFS}${libdir}/locale
}

fix_inittab_swupdate () {
	sed -e 's/1\:2345.*/1\:2345:respawn:\/bin\/sh/' \
		"${IMAGE_ROOTFS}${sysconfdir}/inittab" | \
		sed -e 's/^z6/#&/' | \
		 sed -e 's/.*getty.*//' \
		> "${IMAGE_ROOTFS}${sysconfdir}/inittab.swupdate"
	rm ${IMAGE_ROOTFS}${sysconfdir}/inittab
	mv ${IMAGE_ROOTFS}${sysconfdir}/inittab.swupdate ${IMAGE_ROOTFS}${sysconfdir}/inittab
}

# remove not needed ipkg informations
ROOTFS_POSTPROCESS_COMMAND += "remove_locale_data_files ; "
ROOTFS_POSTPROCESS_COMMAND += "${@bb.utils.contains('SWUPDATE_INIT', 'tiny', 'fix_inittab_swupdate', '',  d)}"
