# Copyright (C) 2011-2012 Freescale Semiconductor
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "${INC_PR}.21"

include linux-g2.inc

COMPATIBLE_MACHINE = "(g2c|g2s)"

SRC_URI_append_g2c += "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=imx-2.6.35-mx28-next;protocol=git \
"
SRCREV_g2c = "2a9fa3b891e4190cf6ff7d2116d13eb0eab09284"
LOCALVERSION_g2c = "-10.12.01+yocto"

SRC_URI_append_g2s = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=imx-2.6.35-mx53-next;protocol=git \
"
SRCREV_g2s = "36e7a56f92c90d16c1052805adc48e104d54a06e"
LOCALVERSION_g2s = "-11.09.01+yocto"

