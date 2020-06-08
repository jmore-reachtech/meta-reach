FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INITSCRIPT_PARAMS_${PN} = "start 70 4 5 . stop 15 0 1 2 3 6 ."
