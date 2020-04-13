FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit useradd
USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM_${PN} = "-g 78 kvm"

