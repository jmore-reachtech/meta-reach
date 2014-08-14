# Append path for freescale layer to include bsp xorg.conf
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_basefilesissue_append () {
    echo "*******************************************************************" >> ${D}${sysconfdir}/issue
    echo "* Type root to login" >> ${D}${sysconfdir}/issue
    echo "*" >> ${D}${sysconfdir}/issue
    echo "* Run net-setup.sh to concfigure network" >> ${D}${sysconfdir}/issue
    echo "*******************************************************************" >> ${D}${sysconfdir}/issue
    echo >> ${D}${sysconfdir}/issue
}
