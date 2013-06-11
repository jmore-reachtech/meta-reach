DESCRIPTION = "Reach Devtools Custom Package"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-custom-dev-tools \
 packagegroup-custom-dev-apps \
"

RDEPENDS_packagegroup-custom-dev-tools = "\
         mtd-utils \
         kobs-ng \
         flash-installer \
         mfg-test \
"

RDEPENDS_packagegroup-custom-dev-apps = "\
		 php \
		 php-fpm \
		 lighttpd-module-fastcgi \
"
