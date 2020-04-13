FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INITSCRIPT_PARAMS_${PN}-sshd = "start 55 3 4 5 . stop 20 0 1 2 6 ."

