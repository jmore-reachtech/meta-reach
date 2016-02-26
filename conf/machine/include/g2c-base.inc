# Provides the g2c common settings
# Include defaults from meta-fsl-arm
require conf/machine/include/imx-base.inc
include conf/machine/include/tune-arm926ejs.inc

SOC_FAMILY = "mxs:mx28:g2c"

PREFERRED_PROVIDER_u-boot = "u-boot-reach"
PREFERRED_PROVIDER_virtual/bootloader = "u-boot-reach"

UBOOT_CONFIG = "mmc nand"
UBOOT_CONFIG[mmc] = "g2c1_mmc_defconfig"
UBOOT_CONFIG[nand] = "g2c1_nand_defconfig"

PREFERRED_PROVIDER_virtual/kernel = "linux-reach"
PREFERRED_VERSION_linux-reach = "4.1%"

KERNEL_IMAGETYPE = "zImage"
KERNEL_DEVICETREE = "imx28-g2c1.dtb"

MACHINE_FEATURES = "touchscreen"
MACHINE_EXTRA_RRECOMMENDS = " kernel-modules"

MKUBIFS_ARGS = "-m 2KiB -e 124KiB -c 1866"
UBINIZE_ARGS = "-m 2KiB -p 128KiB -s 2KiB"

USE_VT = "0"

SERIAL_CONSOLE = "115200 ttyAM0"
