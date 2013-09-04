SUMMARY = "Qt for Embedded Linux (Qt without X11)"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

TOUCH = "tslib tslib-calibrate tslib-tests tsinit"

RDEPENDS_${PN} = " \
        libqt-embeddedclucene4 \
        libqt-embeddedcore4 \
        libqt-embeddedgui4 \
        libqt-embeddedhelp4 \
        libqt-embeddedmultimedia4 \
        libqt-embeddednetwork4 \
        libqt-embeddedscript4 \
        libqt-embeddedscripttools4 \
        libqt-embeddedsql4 \
        libqt-embeddedsvg4 \
        libqt-embeddedtest4 \
        libqt-embeddedxml4 \
        qt4-embedded-qml-plugins \
        qt4-embedded-fonts-ttf-dejavu \
        qt4-embedded-fonts-ttf-vera \
        qt4-embedded-plugin-iconengine-svgicon \
        qt4-embedded-plugin-imageformat-gif \
        qt4-embedded-plugin-imageformat-ico \
        qt4-embedded-plugin-imageformat-jpeg \
        qt4-embedded-plugin-imageformat-mng \
        qt4-embedded-plugin-imageformat-svg \
        qt4-embedded-plugin-imageformat-tiff \
        qt4-embedded-plugin-mousedriver-tslib \
        qt4-embedded-plugin-sqldriver-sqlite \
        ${TOUCH} \
		libicui18n \
"

