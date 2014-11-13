# Provides the g2c common settings
# Include defaults from meta-fsl-arm
require conf/machine/include/mxs-base.inc

IMAGE_BOOTLOADER = "imx-bootlets"
IMXBOOTLETS_MACHINE = "iMX28_EVK"

PREFERRED_PROVIDER_virtual/kernel ?= "linux-g2c"
KERNEL_IMAGETYPE = "zImage"

IMAGE_CLASSES += "image_types_reach"
EXTRA_IMAGEDEPENDS += "imx-bootlets-header-native"

MACHINE_FEATURES = "touchscreen"
MACHINE_EXTRA_RRECOMMENDS = " kernel-modules"

SDCARD_ROOTFS ?= "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.ext3"

MKUBIFS_ARGS = "-m 2KiB -e 124KiB -c 1866"
UBINIZE_ARGS = "-m 2KiB -p 128KiB -s 2KiB"

USE_VT = "0"

# Override the SoC family
SOC_FAMILY = "mxs:mx28:g2c"
SERIAL_CONSOLE = "115200 ttyAM0"
