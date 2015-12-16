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
         ntpclient \
         ethtool \
         iperf \
         net-tools \
"
RDEPENDS_packagegroup-custom-dev-tools_mxs = "\
         mtd-utils-ubifs \
         mtd-utils \
         imx-kobs \
          flash-installer \
"

RDEPENDS_packagegroup-custom-dev-tools-gdb = "\
         gdbserver \
"
