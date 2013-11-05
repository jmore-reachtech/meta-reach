require barebox.inc

PR = "r4"

SRC_URI = "git://github.com/jmore-reachtech/reach-barebox.git;branch=reach-2012-11.0;protocol=git \
	file://defconfig \
	file://config \
	"

SRCREV = "da532b7f809296033c923b7cfe6bb354131e9806"
BOARD = "freescale-mx53-sellwood"

do_configure_prepend() {
	cp ${WORKDIR}/config ${S}/arch/arm/boards/freescale-mx53-sellwood/env
	oe_runmake oldconfig
}

do_compile_append() {
	./scripts/bareboxenv -s arch/arm/boards/${BOARD}/env/ barebox_default_env
}

COMPATIBLE_MACHINE = "g2s"
