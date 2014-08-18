FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-acinclude-use-pkgconfig-for-libxml2-config.patch"

EXTRA_OECONF = "--enable-mbstring \
                --enable-wddx \
                --enable-fpm \
                --with-imap=${STAGING_DIR_HOST} \
                --with-gettext=${STAGING_LIBDIR}/.. \
                --with-imap-ssl=${STAGING_DIR_HOST} \
                --with-zlib=${STAGING_LIBDIR}/.. \
                --with-iconv=${STAGING_LIBDIR}/.. \
                ${COMMON_EXTRA_OECONF} \
"
EXTRA_OECONF_virtclass-native = " \
                --with-zlib=${STAGING_LIBDIR_NATIVE}/.. \
                ${COMMON_EXTRA_OECONF} \
"
