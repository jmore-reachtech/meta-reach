SUMMARY = "Create a basic machine task/package"
LICENSE = "MIT"
PR = "r1"

inherit packagegroup

PROVIDES = "packagegroup-reach-minimal"

#
# packagegroup-minimal contains only the stuff we care about
#
RDEPENDS_packagegroup-reach-minimal = "\
    sysfsutils \
    module-init-tools \
    kernel-module-msdos \
    kernel-module-vfat \
    kernel-module-nls-iso8859-1 \
    kernel-module-nls-cp437 \
    dosfstools \
    rpcbind kernel-module-nfs \
    setserial \
    lrzsz \
    alsa-utils-alsactl \ 
    alsa-utils-alsamixer \
    ${VIRTUAL-RUNTIME_alsa-state} \
    usbutils \
    wireless-tools \
    wpa-supplicant \
"


RRECOMMENDS_packagegroup-reach-minimal = "\
    kernel-module-nls-utf8 \
    kernel-module-input \
    kernel-module-uinput \
    kernel-module-rtc-dev \
    kernel-module-rtc-proc \
    kernel-module-rtc-sysfs \
    kernel-module-unix \
    kernel-module-snd-mixer-oss \
    kernel-module-snd-pcm-oss \
    kernel-module-pxa27x_udc \
    kernel-module-gadgetfs \
    kernel-module-g-file-storage \
    kernel-module-g-serial \
    kernel-module-g-ether \
    kernel-module-uhci-hcd \
    kernel-module-ohci-hcd \
    kernel-module-ehci-hcd \
    kernel-module-usbcore \
    kernel-module-usbhid \
    kernel-module-usbnet \
    kernel-module-sd-mod \
    kernel-module-scsi-mod \
    kernel-module-usbmouse \
    kernel-module-mousedev \
    kernel-module-usbserial \
    kernel-module-usb-storage \
    kernel-module-zd1211rw \
    kernel-module-ieee80211-crypt \
    kernel-module-ieee80211-crypt-ccmp \
    kernel-module-ieee80211-crypt-tkip \
    kernel-module-ieee80211-crypt-wep \
    kernel-module-ecb \
    kernel-module-arc4 \
    kernel-module-crypto_algapi \
    kernel-module-cryptomgr \
    kernel-module-michael-mic \
    kernel-module-aes-generic \
    kernel-module-aes \
    kernel-module-cifs \
    kernel-module-smbfs \
"
