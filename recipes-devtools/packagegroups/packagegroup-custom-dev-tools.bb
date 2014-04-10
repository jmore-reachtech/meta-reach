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
         flash-installer \
"
RDEPENDS_packagegroup-custom-dev-tools_g2c = "\
          kobs-ng \
"

RDEPENDS_packagegroup-custom-dev-tools-gdb = "\
         gdbserver \
"
