DESCRIPTION = "manage IP ranges"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=f0a8ee5f001e1656b1e080654de09273"

DEPENDS = ""

SRCREV = "2bdf99cdd23555d7069b0b6a0a2494d277297b65"
SRC_URI = "git://github.com/firehol/iprange.git"

EXTRA_OECONF += "--disable-man"

S = "${WORKDIR}/git"

inherit autotools

BBCLASSEXTEND = "native"

