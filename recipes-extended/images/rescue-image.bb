SUMMARY = "Root filesystem for swuupdate as rescue system"
DESCRIPTION = "Root FS to start swupdate in rescue mode"

DEPENDS = "u-boot-g2h-nor"

IMAGE_INSTALL = "base-files \
    base-passwd \
    busybox \
    initscripts \
    sysvinit \
    mtd-utils \
    mtd-utils-ubifs \
    libconfig \
    curl \
    util-linux-sfdisk \
    u-boot-g2h \
    openssh-sshd \
    openssh-ssh \
    psplash \
    swupdate-installer \
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

# remove not needed ipkg informations
ROOTFS_POSTPROCESS_COMMAND += "remove_locale_data_files ; "
