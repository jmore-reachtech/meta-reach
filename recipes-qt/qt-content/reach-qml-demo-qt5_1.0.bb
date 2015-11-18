DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRCREV = "c8a70f7d5b52d614602ccb91ba6728e7d54640f0"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo-qt5.git;protocol=ssh"

S = "${WORKDIR}/git"

inherit reach-application-package

do_install_append() {
	install -d ${D}${APP_SRC_DESTDIR}

	case "${MACHINE}" in
		g2h-solo-1 | g2h-solo-13 | g2h-solo-14)
		cp -rf src_640_480/*   ${D}${APP_SRC_DESTDIR}
		;;

		g2h-solo-8 | g2h-solo-11 | g2h-solo-12)
		cp -rf src_1280_800/*   ${D}${APP_SRC_DESTDIR}
		;;

		g2h-solo-2 | g2h-solo-7 | g2h-solo-9 | g2h-solo-6)
		cp -rf src_1024_768/*   ${D}${APP_SRC_DESTDIR}
		;;

		g2h-solo-4 | g2h-solo-3)
		cp -rf src_800_480/*   ${D}${APP_SRC_DESTDIR}
		;;

		*)
		cp -rf src_800_480/*   ${D}${APP_SRC_DESTDIR}
	esac
}

RDEPENDS_${PN} += "bash"

PACKAGE_ARCH = "${MACHINE_ARCH}"
