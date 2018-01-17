# Copyright (C) 2018 Jeff Horn <jeff.horn@reachtech.com>
#
# swupdate allows to generate a compound image for the
# in the "swupdate" format, used for updating the targets
# in field.
#
#
# To use, add swupdate to the inherit clause and set
# set the images (all of them must be found in deploy directory)
# that are part of the compound image.

S = "${WORKDIR}/${PN}"

IMAGE_DEPENDS ?= ""

do_swuimage[dirs] = "${TOPDIR}"
do_swuimage[cleandirs] += "${S}"
do_swuimage[umask] = "022"

do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
do_package[noexec] = "1"
do_package_qa[noexec] = "1"
do_packagedata[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"

def swupdate_getdepends(d):
    def adddep(depstr, deps):
        for i in (depstr or "").split():
            if i not in deps:
                deps.append(i)

    deps = []
    images = (d.getVar('IMAGE_DEPENDS', True) or "").split()
    for image in images:
            adddep(image , deps)

    depstr = ""
    for dep in deps:
        depstr += " " + dep + ":do_build"
    return depstr

python () {
    deps = " " + swupdate_getdepends(d)
    d.appendVarFlag('do_swuimage', 'depends', deps)
}

do_install () {
}

do_createlink () {
    cd ${DEPLOY_DIR_IMAGE}
    ln -sf ${IMAGE_NAME}.mtd.swu ${IMAGE_LINK_NAME}.mtd.swu
    ln -sf ${IMAGE_NAME}.mmc.swu ${IMAGE_LINK_NAME}.mmc.swu
}

python do_swuimage () {
    import shutil

    workdir = d.getVar('WORKDIR', True)
    mtds = (d.getVar('SWUPDATE_MTDS', True) or "").split()
    mmcs = (d.getVar('SWUPDATE_MMCS', True) or "").split()
    s = d.getVar('S', True)
    mtd_list_for_cpio = []
    mmc_list_for_cpio = []

    deploydir = d.getVar('DEPLOY_DIR_IMAGE', True)
    
    for mtd in mtds:
        mtdImage = (d.getVarFlag("SWUPDATE_IMAGES_MTD", mtd, True) or "")
        print mtdImage
        src = os.path.join(deploydir, "%s" % mtdImage)
        dst = os.path.join(s, "%s" % mtd)
        shutil.copyfile(src, dst)
        mtd_list_for_cpio.append(mtd)
            
    line = 'for i in ' + ' '.join(mtd_list_for_cpio) + '; do echo $i;done | cpio -ov -H crc >' + os.path.join(deploydir,d.getVar('IMAGE_NAME', True) + '.mtd.swu')
    os.system("cd " + s + ";" + line)
    
    for mmc in mmcs:
        mmcImage = (d.getVarFlag("SWUPDATE_IMAGES_MMC", mmc, True) or "")
        print mmcImage
        src = os.path.join(deploydir, "%s" % mmcImage)
        dst = os.path.join(s, "%s" % mmc)
        shutil.copyfile(src, dst)
        mmc_list_for_cpio.append(mmc)
            
    line = 'for i in ' + ' '.join(mmc_list_for_cpio) + '; do echo $i;done | cpio -ov -H crc >' + os.path.join(deploydir,d.getVar('IMAGE_NAME', True) + '.mmc.swu')
    os.system("cd " + s + ";" + line)
}

COMPRESSIONTYPES = ""
PACKAGE_ARCH = "${MACHINE_ARCH}"

addtask do_swuimage after do_unpack before do_install
addtask do_createlink after do_swuimage before do_install
