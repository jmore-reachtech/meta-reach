FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INITSCRIPT_PARAMS_${PN}-client = "start 45 3 4 5 . stop 30 0 1 2 6 ."

