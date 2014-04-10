# Provides the g2c common settings

include conf/machine/include/soc-family.inc
include conf/machine/include/tune-arm926ejs.inc

SOC_FAMILY = "mxs"

# Sub-architecture support
MACHINE_SOCARCH ?= ""
MACHINE_SOCARCH_mxs = "${TUNE_PKGARCH}-mx28"
PACKAGE_EXTRA_ARCHS_append = " ${MACHINE_SOCARCH}"

# Disable perf features as 2.6.35.3 fail to build otherwise
PERF_FEATURES_ENABLE = ""

SERIAL_CONSOLE = "115200 ttyAM0"

PREFERRED_PROVIDER_virtual/kernel ?= "linux-g2cl"
PREFERRED_PROVIDER_u-boot ?= "u-boot-fslc"

IMAGE_CLASSES += "image_types_reach"

PREFERRED_VERSION_tslib ?= "1.1"
PREFERRED_VERSION_xserver-nodm-init ?= "1.0"

INHERIT += "fsl-dynamic-packagearch"

