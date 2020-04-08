DESCRIPTION = "FireHOL, an iptables stateful packet filtering firewall for humans!"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=98397354f70a28c9b7dce8a3f162d412"

DEPENDS = "coreutils-native util-linux-native iprange-native"
RDEPENDS_${PN} = "bash coreutils curl util-linux iproute2-tc iputils-ping iputils-traceroute6 iputils-tracepath iprange ncurses tcpdump"
 
SRCREV = "0c9508a95b90cff7230abb6d32ec64f177f9034f"
SRC_URI = "git://github.com/firehol/firehol.git \
           file://install.config \
	   file://firehol \
"

EXTRA_OECONF += "--enable-ipv4 --disable-doc --disable-man --disable-firehol-wizard --disable-link-balancer --disable-update-ipsets "

S = "${WORKDIR}/git"

inherit autotools update-rc.d

do_configure_prepend () {
	export BASH_VERSION="4.4.23"
	export BASH_VERSION_PATH="/bin/bash"
	export IPRANGE_VERSION="1.0.4"
}

do_compile_append () {
	rm sbin/install.config
	cp ${WORKDIR}/install.config sbin/install.config
}

do_install_append () {
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/firehol ${D}${sysconfdir}/init.d/firehol
}

INITSCRIPT_NAME = "firehol"
INITSCRIPT_PARAMS = "start 30 3 4 5 . stop 85 0 1 2 6 ."
