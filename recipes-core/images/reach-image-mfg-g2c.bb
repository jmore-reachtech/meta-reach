require recipes-core/images/reach-image-mfg.inc

REACH_MFG_TEST_PACKAGE = "mfg-test-g2c"

CORE_IMAGE_EXTRA_INSTALL += "openssh \
"

COMPATIBLE_MACHINE = "(g2c)"
