FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INITSCRIPT_PARAMS = "start 55 4 5 . stop 30 0 1 2 3 6 ."
