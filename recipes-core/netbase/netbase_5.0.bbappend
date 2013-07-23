# Append path for freescale layer to include bsp xorg.conf 
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}_${PV}:"

PRINC := "${@int(PRINC) + 1}"

SRC_URI += " file://net-setup.sh \
"

do_install_append () {
	install -d ${D}${sbindir}
	install -m 755 ${WORKDIR}/net-setup.sh ${D}${sbindir}
}
