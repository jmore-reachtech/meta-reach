##
# See cinematicexperience_1.0.bb for video info
# Use this video setting for uboot:
# setenv mmcargs setenv bootargs console=${console},${baudrate} root=${mmcroot} fbmem=24M video=mxcfb0:dev=ldb,LDB-WVGA,if=RGB666,bpp=32
##
DESCRIPTION = "A very basic qt5 image with a demo"

IMAGE_FEATURES += "splash x11-base"

LICENSE = "MIT"

IMAGE_OVERHEAD_FACTOR = "2.0"

IMAGE_INSTALL_append = " packagegroup-custom-x11-apps \
	packagegroup-custom-x11-tools \
	packagegroup-custom-dev-tools \
	packagegroup-custom-dev-tools-gdb \
	packagegroup-custom-core \
"

inherit core-image

#QT5:
IMAGE_INSTALL += " \
    strace \
    ltrace \
    cpufrequtils \
    nano \
    packagegroup-fsl-gstreamer \
    packagegroup-fsl-tools-testapps \
    packagegroup-fsl-tools-benchmark \
    gstreamer \
    gst-plugins-base-app \
    gst-plugins-base \
    gst-plugins-good \    
    openbox \
    openbox-theme-clearlooks \
    gst-plugins-gl-opengl \
    coreutils \
    elfutils-dev \
    enca \
    gcc \
    libass \
    libdvdread \
    libfaad \
    fribidi \
    libgcc \
    gmp \
    libice \
    libice-dev \
    libmpc \
    mpfr \
    libsm \
    libsm-dev \
    libx11 \
    libxcalibrate \
    libxext \
    libxinerama \
    libxmu \
    libxt \
    linux-libc-headers-dev \
    make \
    mkfontdir \
    mkfontscale \
    x11-common-dev \
    xextproto-dev \
    xproto-dev \
    xserver-xorg-dev \
    xserver-xorg-multimedia-modules \
    xserver-xorg-utils \    
    icu \
    qtbase-fonts \
    qtbase-plugins \
    qtbase-examples \
    qtbase-tools \
    qtdeclarative \
    qtdeclarative-plugins \
    qtdeclarative-tools \
    qtdeclarative-examples \
    qtdeclarative-qmlplugins \
    qtmultimedia \
    qtmultimedia-plugins \
    qtmultimedia-examples \
    qtmultimedia-qmlplugins \
    qtsvg \
    qtsvg-plugins \
    qtsensors \
    qtimageformats-plugins \
    qtsystems \
    qtsystems-tools \
    qtsystems-examples \
    qtsystems-qmlplugins \
    qtscript \
    qtwebkit \
    qtwebkit-examples-examples \
    qtwebkit-qmlplugins \
    qt3d \
    qt3d-examples \
    qt3d-qmlplugins \
    qt3d-tools \
    reach-qt5-demo \
    "


export IMAGE_BASENAME = "reach-image-qt5"
