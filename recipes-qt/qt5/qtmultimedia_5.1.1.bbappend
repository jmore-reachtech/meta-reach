SRC_URI += "file://Using_glimagesink_instead_of_xvimagesink.patch \
"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PRINC = "1"

FILES_${PN} += " Using_glimagesink_instead_of_xvimagesink.patch "
