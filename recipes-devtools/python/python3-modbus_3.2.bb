DESCRIPTION = "Modbus Server and Client programs using Python-3"
SECTION = "devel/python"
HOMEPAGE = "https://pypi.org/project/modbus/"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

inherit pypi setuptools3

PYPI_PACKAGE = "modbus"

SRC_URI[md5sum] = "aef95358312db46d21bf540326bb0edb"
SRC_URI[sha256sum] = "f4cd6efa24e7e2c5295672467722c2ed32faec7f43bbc1cabafe8a9f521439f2"

RDEPENDS_${PN} += "${PYTHON_PN}-numpy"
