# Adapted from linux-imx_${PV}.bb, copyright (C) 2013 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

include linux-g2h.inc
require recipes-kernel/linux/linux-dtb.inc

SRCREV = "22220c419db36093e18fed1eb1e190bd60a525f7"

LOCALVERSION = "-3.10.17-reach"

COMPATIBLE_MACHINE = "(g2h)"
