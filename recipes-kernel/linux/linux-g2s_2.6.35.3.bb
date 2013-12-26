# Copyright (C) 2011-2012 Freescale Semiconductor
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "${INC_PR}.22"

include linux-g2s.inc

COMPATIBLE_MACHINE = "(g2s)"

SRC_URI_append_g2s = "git://github.com/jmore-reachtech/reach-imx-linux.git;branch=imx-2.6.35-mx53-next;protocol=git \
"

SRCREV_g2s = "f10bfbd53a576d33b3dc9122913cf83a897e7f81"
LOCALVERSION_g2s = "-11.09.01+yocto"

