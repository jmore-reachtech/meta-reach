FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

INITSCRIPT_PARAMS = "start 60 4 5 . stop 20 0 1 2 3 6 ."
