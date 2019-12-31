#@TYPE: Machine
#@NAME: reach

#@DESCRIPTION: Machine configuration for reach systems

MACHINEOVERRIDES =. "mx6:mx6dl:mx6q:"

include conf/machine/include/imx-base.inc
include conf/machine/include/tune-cortexa9.inc

KERNEL_DEVICETREE = " \
	imx6dl-g3-7res.dtb \
	imx6dl-g3-7pcap.dtb \
	imx6dl-g3-10p1res.dtb \
	imx6dl-g3-10p1pcap.dtb \
	imx6dl-g3-none.dtb \
"

KERNEL_IMAGETYPE = "zImage"

PREFERRED_PROVIDER_u-boot ?= "u-boot-reach"
PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot-reach"

PREFERRED_PROVIDER_virtual/kernel ??= "linux-reach"
PREFERRED_PROVIDER_virtual/kernel_use-mainline-bsp ??= "linux-fslc"
PREFERRED_VERSION_linux-reach ??= "4.9"

UBOOT_MACHINE ?= "reach_imx6dl_g3_defconfig"

SERIAL_CONSOLE = "115200 ttymxc0"

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += " \
    kernel-image \
    kernel-devicetree \
"
MACHINE_HAS_VIVANTE_KERNEL_DRIVER_SUPPORT = "1"
MACHINE_USES_VIVANTE_KERNEL_DRIVER_MODULE = "0"

MACHINE_FEATURES_BACKFILL_CONSIDERED = "rtc"

WKS_FILES = "imx-uboot.wks"

USE_VT = "0"

# Mender configuration

IMAGE_FSTYPES = ""

MENDER_ARTIFACT_NAME ?= "0.0.0.1"
ARTIFACTIMG_FSTYPE = "ext4"
IMAGE_ROOTFS_SIZE = "1048576"

MENDER_STORAGE_DEVICE = "/dev/mmcblk2"
MENDER_STORAGE_TOTAL_SIZE_MB = "2624"
MENDER_DATA_PART_SIZE_MB = "512"
MENDER_PARTITION_ALIGNMENT = "1048576"

MENDER_FEATURES_ENABLE_append = " mender-uboot mender-image mender-image-sd mender-install"
MENDER_FEATURES_DISABLE_append = " mender-systemd mender-grub mender-image-uefi"

MENDER_UBOOT_STORAGE_DEVICE = "0"
MENDER_UBOOT_STORAGE_INTERFACE = "mmc"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET = "1048576"

MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET = "2"
