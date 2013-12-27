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
         php \
		 php-fpm \
		 lighttpd-module-fastcgi \
         reach-version \
         ntpclient \
         reach-info \
         devregs \
"
