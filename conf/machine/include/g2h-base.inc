# Include Freescale i.MX base settings
require conf/machine/include/imx-base.inc
include conf/machine/include/tune-cortexa9.inc

USE_VT = "0"

SOC_FAMILY = "mx6:mx6dl:g2h"

PREFERRED_PROVIDER_u-boot = "u-boot-reach"
PREFERRED_PROVIDER_virtual/bootloader = "u-boot-reach"

UBOOT_CONFIG[g2h-10_1-inch] = "g2h_10_1_defconfig"
UBOOT_CONFIG[g2h-7-inch] = "g2h_7_defconfig"
UBOOT_CONFIG[g2h-5_7-inch] = "g2h_5_7_defconfig"

PREFERRED_PROVIDER_virtual/kernel = "linux-reach"
PREFERRED_VERSION_linux-reach = "3.14+%"

KERNEL_IMAGETYPE = "zImage"

SERIAL_CONSOLE = "115200 ttymxc0"
SIO_TTY = "/dev/ttymxc1"

MKUBIFS_ARGS = "-m 2KiB -e 124KiB -c 4096"
UBINIZE_ARGS = "-m 2KiB -p 128KiB -s 2KiB"

QPA_TOUCH_PLUGIN ?= "Tslib"

MACHINE_FEATURES_BACKFILL_CONSIDERED = "rtc"
