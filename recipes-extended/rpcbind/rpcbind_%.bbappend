FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INITSCRIPT_PARAMS = "start 40 3 4 5 . stop 35 0 1 2 6 ."
