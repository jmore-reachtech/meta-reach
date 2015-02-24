DESCRIPTION = "Reach Core Custom Package"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
 packagegroup-custom-core \
"

RDEPENDS_packagegroup-custom-core = "\
         openssh-sshd \
         openssh-ssh \
         openssh-scp \
         openssh-sftp-server \
         samba-lite \
         libsmbclient \
         libsmbclient-dev \
         lighttpd \
         php \
	 php-fpm \
	 lighttpd-module-fastcgi \
         reach-version \
         ntpclient \
         reach-info \
         devregs \
"
