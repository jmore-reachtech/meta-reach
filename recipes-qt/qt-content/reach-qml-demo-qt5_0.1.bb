DESCRIPTION = "Reach qml-viewer demo content and plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

SRCREV = "cb6a25074049dbb33ca70744a4cb61876b5b8636"
SRC_URI = "git://git@github.com/jmore-reachtech/reach-qml-demo-qt5.git;protocol=http"

S_BASE = "${WORKDIR}/git/src_"
APP_DIR = "/application/src"

do_install() {
        install -d ${D}${APP_DIR}

        case "${MACHINE}" in
          g2h-solo-1)
            cp -rf ${S_BASE}640_480/*   ${D}${APP_DIR}
            ;;

           g2h-solo-2 | g2h-solo-7)
            cp -rf ${S_BASE}1024_768/*   ${D}${APP_DIR}
            ;;
         
		   g2h-solo-4 | g2h-solo-3)
            cp -rf ${S_BASE}800_480/*   ${D}${APP_DIR}
			;;

           *)
            cp -rf ${S_BASE}800_480/*   ${D}${APP_DIR}
        esac
}

FILES_${PN} = "${APP_DIR}"

