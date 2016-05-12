DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRCREV = "1e18bbb459e220d284efb04f40f9b404c7c41857"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo-qt5.git;protocol=ssh \
           file://settings.json \
"

S = "${WORKDIR}/git"

inherit reach-application-package

do_install_append() {
	install -d ${D}${APP_SRC_DESTDIR}

	case "${MACHINE}" in
		g2h-5_7-inch)
		cp -rf src_640_480/*   ${D}${APP_SRC_DESTDIR}
		;;

		g2h-10_1-inch)
		cp -rf src_1024_768/*   ${D}${APP_SRC_DESTDIR}
		;;

		g2h-7-inch)
		cp -rf src_800_480/*   ${D}${APP_SRC_DESTDIR}
		;;

		*)
		cp -rf src_800_480/*   ${D}${APP_SRC_DESTDIR}
	esac
	cp -f ${WORKDIR}/settings.json ${D}${APP_SRC_DESTDIR}
}

RDEPENDS_${PN} += "bash"

PACKAGE_ARCH = "${MACHINE_ARCH}"
