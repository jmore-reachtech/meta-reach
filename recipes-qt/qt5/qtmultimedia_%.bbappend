PACKAGECONFIG_append_pn-qtmultimedia = " gstreamer010 "

SRC_URI_remove = "\
    file://0001-Initial-porting-effort-to-GStreamer-1.0.patch \
    file://0002-qtmultimedia.pro-Respect-OE_GSTREAMER_ENABLED-OE_GST.patch \
"
