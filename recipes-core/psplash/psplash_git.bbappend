FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRCREV = "14c8f7b705de944beb4de3f296506d80871e410f"

SRC_URI += "file://psplash-colors.h \
"

do_configure_append () {
    cp ${WORKDIR}/psplash-colors.h ${S}
    touch ${S}/psplash.c
}
