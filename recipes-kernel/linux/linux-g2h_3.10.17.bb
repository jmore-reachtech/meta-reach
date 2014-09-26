# Adapted from linux-imx_${PV}.bb, copyright (C) 2013 O.S. Systems Software LTDA
# Released under the MIT license (see COPYING.MIT for the terms)

include linux-g2h.inc
require recipes-kernel/linux/linux-dtb.inc

SRCREV = "bae29f19849345dbe063764f52860201d3439c5d"

LOCALVERSION = "-3.10.17-reach"

DEPENDS += "lzop-native bc-native"

COMPATIBLE_MACHINE = "(g2h)"
