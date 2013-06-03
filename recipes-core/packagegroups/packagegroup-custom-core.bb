DESCRIPTION = "Reach Core Custom Package"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-custom-core \
"

RDEPENDS_packagegroup-custom-core = "\
         dropbear \
         samba \
         lighttpd \
"
