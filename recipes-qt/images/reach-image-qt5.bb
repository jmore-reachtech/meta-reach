DESCRIPTION = "A qt5 image"

LICENSE = "CLOSED"

inherit core-image
inherit populate_sdk_qt5

FIRMWARE = " \
    linux-firmware-ibt \
    linux-firmware-iwlwifi \
    linux-firmware-mt7601u \
    linux-firmware-rtl8188 \
    linux-firmware-rtl8192cu \
    linux-firmware-rtl8192ce \
    linux-firmware-rtl8192su \
    linux-firmware-rtl8723 \
    linux-firmware-rtl8821 \
"

FONTS = " \
    liberation-fonts \
    ttf-dejavu-sans \
    ttf-dejavu-serif \
    ttf-dejavu-common \
"

FS_TOOLS = " \
    dosfstools \
    e2fsprogs \
    e2fsprogs-mke2fs \
    e2fsprogs-resize2fs \
    e2fsprogs-tune2fs \
    parted \
"

LIBRARIES = " \
    libftdi \
    libgpiod \
    libgpiod-python \
    libgpiod-tools \
    libmodbus \
    libsocketcan \
    libusb1 \
"

MEDIA = " \
    alsa-utils \
    imx-codec-aac \
    packagegroup-fsl-gstreamer1.0-full \
    pulseaudio-server \
    pulseaudio-misc \
"

PYTHON3 = " \
    python3-modules \
    python3-pip \
    python3-can \
    python3-jinja2 \
    python3-modbus \
    python3-pillow \
    python3-psutil \
    python3-pyqt5 \
    python3-pyserial \
    python3-pyusb \
    python3-requests \
    python3-smbus2 \
    python3-tornado \
"

QT5 = " \
    qt3d \
    qtcanvas3d \
    qtcharts \
    qtconnectivity \
    qtdatavis3d \
    qtdeclarative \
    qtdeclarative-tools \
    qtgraphicaleffects \
    qtimageformats \
    qtlocation \
    qtmultimedia \
    qtnetworkauth \
    qtquickcontrols \
    qtquickcontrols2 \
    qtremoteobjects \
    qtscxml \
    qtsensors \
    qtserialbus \
    qtserialport \
    qttools \
    qtsvg \
    qtvirtualkeyboard \
    qtwebsockets \
    qtwebview \
    qtxmlpatterns \
"

REACH = " \
    mkemmc \
    reach-qml-medical \
    reach-qml-viewer \
    reach-qml-viewer-tscal \
    reach-resize \
    splash \
"

SYS_TOOLS = " \
    bash \
    bind-utils \
    busybox-ifplugd \
    busybox-hwclock \
    can-utils \
    chkconfig  \
    coreutils \
    cronie \
    devregs \
    dhcp-client \
    ethtool \
    file \
    firehol \
    gdbserver \
    htop \
    i2c-tools \
    iproute2 \
    iproute2-genl \
    iproute2-lnstat \
    iproute2-ss \
    jsoncpp \
    lighttpd \
    lrzsz \
    lsof \
    mmc-utils \
    mosquitto \
    net-tools \
    nfs-utils-client \
    nginx \
    nodejs \
    nodejs-npm \
    ntp \
    ntp-utils \
    ntpdate \
    open62541 \
    openssh\
    openssh-scp\
    openssh-sftp-server \
    openssl-bin \
    picocom \
    ppp \
    procps \
    redis hiredis \
    rsync \
    strace \
    syslog-ng \
    udev-extraconf \
    vim \
"

TOUCH = " \
    tslib \
    tslib-calibrate \
    tslib-tests \
"

CORE_IMAGE_EXTRA_INSTALL += " \
    ${FIRMWARE} \
    ${FONTS} \
    ${FS_TOOLS} \
    ${LIBRARIES} \
    ${MEDIA} \
    ${PYTHON3} \
    ${QT5} \
    ${REACH} \
    ${SYS_TOOLS} \
    ${TOUCH} \
    docker docker-contrib \
"


def get_layers(bb, d):
        layers = (d.getVar("BBLAYERS", d, 1) or "").split()
        layers_branch_rev = ["%-17s = \"%s:%s\"" % (os.path.basename(i), \
                base_get_metadata_git_branch(i, None).strip().strip('()'), \
                base_get_metadata_git_revision(i, None)) \
                        for i in layers]
        i = len(layers_branch_rev)-1
        p1 = layers_branch_rev[i].find("=")
        s1= layers_branch_rev[i][p1:]
        while i > 0:
                p2 = layers_branch_rev[i-1].find("=")
                s2= layers_branch_rev[i-1][p2:]
                if s1 == s2:
                        layers_branch_rev[i-1] = layers_branch_rev[i-1][0:p2]
                        i -= 1
                else:
                        i -= 1
                        p1 = layers_branch_rev[i].find("=")
                        s1= layers_branch_rev[i][p1:]

        layertext = "%s\n" % '\n'.join(layers_branch_rev)
        layertext = layertext.replace('<','')
        layertext = layertext.replace('>','')
        return layertext

write_meta_layers() {
    echo "${DISTRO} ${DISTRO_VERSION}"  > ${IMAGE_ROOTFS}/etc/reach-version
    echo "BB_VERSION        = ${BB_VERSION}" >> ${IMAGE_ROOTFS}/etc/reach-version
    echo "TARGET_ARCH       = ${TARGET_ARCH}" >> ${IMAGE_ROOTFS}/etc/reach-version
    echo "TARGET_OS         = ${TARGET_OS}" >> ${IMAGE_ROOTFS}/etc/reach-version
    echo "MACHINE           = ${MACHINE}" >> ${IMAGE_ROOTFS}/etc/reach-version
    echo "TUNE_FEATURES     = ${TUNE_FEATURES}" >> ${IMAGE_ROOTFS}/etc/reach-version
    echo "TARGET_FPU        = ${TARGET_FPU}" >> ${IMAGE_ROOTFS}/etc/reach-version
    echo "${@get_layers(bb, d)}" >> ${IMAGE_ROOTFS}/etc/reach-version
}

write_software_release() {
    echo ${MENDER_ARTIFACT_NAME} > ${IMAGE_ROOTFS}/etc/reach-release
}

ROOTFS_POSTPROCESS_COMMAND_append = " \
    write_meta_layers; \
    write_software_release; \
"
