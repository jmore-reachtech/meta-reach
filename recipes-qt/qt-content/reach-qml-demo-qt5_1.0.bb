DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRCREV = "4d14283a2ac4c6454a5036caea443d5f88558f3e"
SRC_URI = "git://github.com/jmore-reachtech/reach-qml-demo-qt5.git \
           file://settings.json \
"

S = "${WORKDIR}/git"

inherit reach-application-package

do_install_append() {
	install -d ${D}${APP_SRC_DESTDIR}

	case "${MACHINE}" in
		g2h-5_7-inch | g2h-5_7_f-inch)
		cp -rf src_640_480/*   ${D}${APP_SRC_DESTDIR}
		;;

		g2h-10_4-inch)
		cp -rf src_1024_768/*   ${D}${APP_SRC_DESTDIR}
		;;

		g2h-10_1-inch)
		cp -rf src_1280_800/*   ${D}${APP_SRC_DESTDIR}
		;;

		g2h-7-inch | g2h-7_f-inch)
		cp -rf src_800_480/*   ${D}${APP_SRC_DESTDIR}
		;;

		*)
		cp -rf src_800_480/*   ${D}${APP_SRC_DESTDIR}
	esac
	cp -f ${WORKDIR}/settings.json ${D}${APP_SRC_DESTDIR}
}

RDEPENDS_${PN} += "bash"

PACKAGE_ARCH = "${MACHINE_ARCH}"
