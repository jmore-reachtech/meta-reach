DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRCREV = "3241e5ff3d102684df556317bc6cbff680ba3ff6"
SRC_URI = "git://github.com/jmore-reachtech/reach-qml-demo-qt5.git;branch=dizzy;protocol=git \
"

S_BASE = "${WORKDIR}/git/src_"
APP_DIR = "/application/src"
S = "${WORKDIR}/git"

do_install() {
        install -d ${D}${APP_DIR}

        case "${MACHINE}" in
          g2h-solo-1 | g2h-solo-13 | g2h-solo-14 | g2h-solo-13f | g2h-solo-14f)
            cp -rf ${S_BASE}640_480/*   ${D}${APP_DIR}
          ;;

          g2h-solo-8 | g2h-solo-11f | g2h-solo-11f-r |g2h-solo-12f | g2h-solo-18f)
            cp -rf ${S_BASE}1280_800/*   ${D}${APP_DIR}
          ;;

          g2h-solo-2 | g2h-solo-7 | g2h-solo-9 | g2h-solo-6)
            cp -rf ${S_BASE}1024_768/*   ${D}${APP_DIR}
          ;;
         
	  g2h-solo-4 | g2h-solo-3 | g2h-solo-4f | g2h-solo-3f)
            cp -rf ${S_BASE}800_480/*   ${D}${APP_DIR}
	  ;;

          *)
            cp -rf ${S_BASE}800_480/*   ${D}${APP_DIR}
        esac
}

FILES_${PN} = "${APP_DIR}"

