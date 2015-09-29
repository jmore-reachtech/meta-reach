# Include Freescale i.MX base settings
require conf/machine/include/imx-base.inc

include conf/machine/include/tune-cortexa9.inc

IMAGE_CLASSES += "image_types_reach"

USE_VT = "0"
