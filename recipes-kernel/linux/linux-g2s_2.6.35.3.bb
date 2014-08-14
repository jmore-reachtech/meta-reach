# Copyright (C) 2011-2012 Freescale Semiconductor
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "${INC_PR}.22"

include linux-g2s.inc

COMPATIBLE_MACHINE = "(g2s)"

SRC_URI_append_g2s = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=imx-2.6.35-mx53-master;protocol=git \
"

SRCREV_g2s = "ea6615758dfd7d1ea0b9646424f9051efaa7173c"
LOCALVERSION_g2s = "-11.09.01+yocto"

