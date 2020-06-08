FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INITSCRIPT_PARAMS = "start 20 2 3 4 5 . stop 65 0 1 6 ."
