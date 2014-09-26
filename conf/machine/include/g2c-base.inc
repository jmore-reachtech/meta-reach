# Provides the g2c common settings
# Include defaults from meta-fsl-arm
require conf/machine/include/mxs-base.inc

PREFERRED_PROVIDER_virtual/kernel ?= "linux-g2c"

IMAGE_CLASSES += "image_types_reach"

PREFERRED_VERSION_tslib ?= "1.1"
PREFERRED_VERSION_xserver-nodm-init ?= "1.0"

# Override the SoC family
SOC_FAMILY = "mxs:mx28:g2c"
SERIAL_CONSOLE = "115200 ttyAM0"
