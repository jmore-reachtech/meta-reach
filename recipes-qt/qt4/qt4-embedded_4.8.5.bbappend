FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://003-Hack-hide-cursor-during-startup.patch"

PRINC := "${@int(PRINC) + 1}"

QT_QT3SUPPORT = "-no-qt3support"
QT_XML = "-no-xmlpatterns"
WEB = "web-webkit"
QT_PHONON = "-no-phonon"
QT_DBUS = "-no-qdbus"
QT_MULTIMEDIA = "-no-pulseaudio" 
