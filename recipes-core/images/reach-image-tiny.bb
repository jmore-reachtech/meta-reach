DESCRIPTION = "A minimal console based image used for testing"

LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690 \
                     file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit image

IMAGE_INSTALL_append = "\
  busybox \
  busybox-mdev \
  base-passwd \
  base-files \
  reach-overlay \
"

# Create /etc/timestamp during image construction to give a reasonably sane default time setting
ROOTFS_POSTPROCESS_COMMAND += "rootfs_update_timestamp ; "

export IMAGE_BASENAME = "reach-image-tiny"
