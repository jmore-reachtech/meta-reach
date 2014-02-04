# Provides the i.MX common settings

include conf/machine/include/soc-family.inc
include conf/machine/include/tune-cortexa8.inc

PREFERRED_PROVIDER_virtual/kernel ?= "linux-g2s"
PREFERRED_VERSION_barebox = "2012.11.0"
PREFERRED_PROVIDER_virtual/xserver = "xserver-xorg"

IMAGE_CLASSES += "image_types_reach"

# Disable perf features as 2.6.35.3 fail to build otherwise
PERF_FEATURES_ENABLE = ""

PREFERRED_VERSION_xserver-xorg_mx6 = "2:1.11.4"

XSERVER_DRIVER = "xf86-video-fbdev"
XSERVER_DRIVER_mx5 = "xf86-video-imxfb"
XSERVER_DRIVER_mx6 = "xf86-video-imxfb-vivante"
XSERVER = "xserver-xorg \
           xf86-input-tslib \
           xf86-input-evdev \
           ${XSERVER_DRIVER}"

# Ship kernel modules
MACHINE_EXTRA_RRECOMMENDS = "kernel-modules"

# Firmware
MACHINE_FIRMWARE ?= ""
MACHINE_FIRMWARE_append_mx6q = " firmware-imx-vpu-imx6q"
MACHINE_FIRMWARE_append_mx6d = " firmware-imx-vpu-imx6d"
MACHINE_FIRMWARE_append_mx6dl = " firmware-imx-vpu-imx6d"
MACHINE_FIRMWARE_append_mx53 = " firmware-imx-vpu-imx53 firmware-imx-sdma-imx53"
MACHINE_FIRMWARE_append_mx51 = " firmware-imx-vpu-imx51 firmware-imx-sdma-imx51"

MACHINE_EXTRA_RRECOMMENDS += "${MACHINE_FIRMWARE}"

# Extra audio support
# FIXME: Add support for ALL SoC families
MACHINE_EXTRA_RRECOMMENDS_append_mx5 = " imx-audio"
MACHINE_EXTRA_RRECOMMENDS_append_mx6 = " imx-audio"

# Extra udev rules
MACHINE_EXTRA_RRECOMMENDS += "udev-extraconf"

# Gstreamer plugin
MACHINE_GSTREAMER_PLUGIN ?= "gst-fsl-plugin"
MACHINE_GSTREAMER_PLUGIN_mx3 ?= ""

# mx5 GPU libraries
PREFERRED_PROVIDER_virtual/egl_mx5 ?= "amd-gpu-x11-bin-mx51"
PREFERRED_PROVIDER_virtual/libgles1_mx5 ?= "amd-gpu-x11-bin-mx51"
PREFERRED_PROVIDER_virtual/libgles2_mx5 ?= "amd-gpu-x11-bin-mx51"

# mx6 GPU libraries
PREFERRED_PROVIDER_virtual/egl_mx6 ?= "gpu-viv-bin-mx6q"
PREFERRED_PROVIDER_virtual/libgl_mx6 ?= "gpu-viv-bin-mx6q"
PREFERRED_PROVIDER_virtual/libgles1_mx6 ?= "gpu-viv-bin-mx6q"
PREFERRED_PROVIDER_virtual/libgles2_mx6 ?= "gpu-viv-bin-mx6q"

#PREFERRED_PROVIDER_virtual/kernel_mx3 = "linux-fslc"

EXTRA_IMAGEDEPENDS = "barebox"

SDCARD_ROOTFS ?= "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.ext3"
IMAGE_FSTYPES ?= "tar.bz2 ext3 sdcard"

SERIAL_CONSOLE = "115200 ttymxc0"

KERNEL_IMAGETYPE = "zImage"

MACHINE_FEATURES = "apm usbgadget usbhost vfat alsa touchscreen"