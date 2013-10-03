DESCRIPTION = "Reach Devtools Custom Package"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-custom-dev-tools \
 packagegroup-custom-dev-tools-gdb \
"

RDEPENDS_packagegroup-custom-dev-tools = "\
         mtd-utils-ubifs \
         mtd-utils \
         kobs-ng \
         flash-installer \
         mfg-test \
"

RDEPENDS_packagegroup-custom-dev-tools-gdb = "\
         gdbserver \
"
