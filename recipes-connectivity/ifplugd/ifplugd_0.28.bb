DESCRIPTION = "ifplugd is a Linux daemon which will automatically configure your ethernet device \
when a cable is plugged in and automatically unconfigure it if the cable is pulled."
HOMEPAGE = "http://0pointer.de/lennart/projects/ifplugd/"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=94d55d512a9ba36caa9b7df079bae19f"

DEPENDS = "libdaemon"

SRC_URI = "http://0pointer.de/lennart/projects/ifplugd/ifplugd-${PV}.tar.gz \
	   file://ifplugd \
"

SRC_URI[md5sum] = "df6f4bab52f46ffd6eb1f5912d4ccee3"
SRC_URI[sha256sum] = "474754ac4ab32d738cbf2a4a3e87ee0a2c71b9048a38bdcd7df1e4f9fd6541f0"

inherit autotools update-rc.d

do_install_append () {
	# replace init with our version
	rm ${D}${sysconfdir}/init.d/ifplugd
	install -m 0755 ${WORKDIR}/ifplugd ${D}${sysconfdir}/init.d/
}

EXTRA_OECONF = "--disable-lynx --with-initdir=${sysconfdir}/init.d"

INITSCRIPT_NAME = "ifplugd"
INITSCRIPT_PARAMS_${PN} = "start 30 3 4 5 . stop 80 0 1 2 6 ."

CONFFILES_${PN} = "${sysconfdir}/ifplugd/ifplugd.conf"

RDEPENDS_${PN} += "bash"
