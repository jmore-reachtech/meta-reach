# Provides the g2c common settings

include conf/machine/include/soc-family.inc
include conf/machine/include/tune-arm926ejs.inc
include conf/machine/include/g2-default-providers.inc
include conf/machine/include/g2-default-versions.inc

# Disable perf features as 2.6.35.3 fail to build otherwise
PERF_FEATURES_ENABLE = ""

SERIAL_CONSOLE = "115200 ttyAM0"

IMAGE_CLASSES += "image_types_reach"

