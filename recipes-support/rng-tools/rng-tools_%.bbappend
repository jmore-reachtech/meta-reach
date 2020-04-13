FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INITSCRIPT_PARAMS = "start 10 2 3 4 5 . stop 50 0 1 6 ."
