require barebox.inc

PR = "r5"

SRC_URI = "git://github.com/jmore-reachtech/reach-barebox.git;branch=reach-2012-11.0;protocol=ssh \
	file://defconfig \
	file://config \
	"

SRCREV = "d6208d9e84dba38428ac87a80efc23bd94619ab9"
BOARD = "freescale-mx53-sellwood"

do_configure_prepend() {
	cp ${WORKDIR}/config ${S}/arch/arm/boards/freescale-mx53-sellwood/env
	oe_runmake oldconfig
}

do_compile_append() {
	./scripts/bareboxenv -s arch/arm/boards/${BOARD}/env/ barebox_default_env
}

COMPATIBLE_MACHINE = "g2s"
