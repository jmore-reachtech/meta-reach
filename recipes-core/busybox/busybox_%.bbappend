FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INITSCRIPT_PARAMS_${PN}-syslog = "start 20 3 4 5 . stop 60 0 1 2 6 ."

