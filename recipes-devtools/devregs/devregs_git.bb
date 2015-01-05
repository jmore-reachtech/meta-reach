DESCRIPTION = "i.MX Register tool"
SECTION = "devel"
LICENSE = "GPL-1"
LIC_FILES_CHKSUM = "file://COPYING;md5=5003fa041d799dd5dd5f646b74e36924"

SRCREV = "4fffb7de640a1fe56d4ce18fffe74dfaec31f81a"
SRC_URI = "git://github.com/boundarydevices/devregs.git;protocol=http"

PV = "1.0+${SRCPV}"

S = "${WORKDIR}/git"

inherit autotools-brokensep
