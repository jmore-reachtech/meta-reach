FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

EXTRA_OECONF = "--enable-spincludedir=${STAGING_INCDIR}/OpenSP \
                --enable-splibdir=${STAGING_LIBDIR} \
                --enable-static --disable-shared"


do_install() {
    # Refer to http://www.linuxfromscratch.org/blfs/view/stable/pst/openjade.html
    # for details.
    install -d ${D}${bindir}
    # openjade is no longer built with shared lib option due to a bug
    # (see the EXTRA_OECONF options for details).
    #install -m 0755 ${S}/jade/.libs/openjade ${D}${bindir}/openjade
    install -m 0755 ${S}/jade/openjade ${D}${bindir}/openjade
    ln -sf openjade ${D}${bindir}/jade

    # EXTRA_OECONF (see above) now disables shared lib
    #oe_libinstall -a -so -C style libostyle ${D}${libdir}
    #oe_libinstall -a -so -C spgrove libospgrove ${D}${libdir}
    #oe_libinstall -a -so -C grove libogrove ${D}${libdir}

    install -d ${D}${datadir}/sgml/openjade-${PV}
    install -m 644 dsssl/catalog ${D}${datadir}/sgml/openjade-${PV}
    install -m 644 dsssl/*.dtd ${D}${datadir}/sgml/openjade-${PV}
    install -m 644 dsssl/*.dsl ${D}${datadir}/sgml/openjade-${PV}
    install -m 644 dsssl/*.sgm ${D}${datadir}/sgml/openjade-${PV}

    install -d ${datadir}/sgml/openjade-${PV}
    install -m 644 dsssl/catalog ${datadir}/sgml/openjade-${PV}/catalog

    install -d ${D}${sysconfdir}/sgml
    echo "CATALOG ${datadir}/sgml/openjade-${PV}/catalog" > \
            ${D}${sysconfdir}/sgml/openjade-${PV}.cat
}
