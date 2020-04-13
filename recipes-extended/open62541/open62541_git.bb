SUMMARY = "Open source implementation of OPC UA"
HOMEPAGE = "http://open62541.org/"
LICENSE = "MPL-2.0"

LIC_FILES_CHKSUM = "file://LICENSE;md5=815ca599c9df247a0c7f619bab123dad"

SRC_URI = "git://github.com/open62541/open62541.git;protocol=https;branch=${BRANCH} \
           git://github.com/OPCFoundation/UA-Nodeset.git;protocol=https;branch=v1.04;destsuffix=deps/ua-nodeset;name=ua-nodeset \
           git://github.com/Pro/mdnsd.git;protocol=https;branch=master;destsuffix=deps/mdnsd;name=mdnsd \
	   "

BRANCH = "1.0"
SRCREV = "e4309754fc2f6ea6508b59ca82e08c27b0118d74"

SRCREV_ua-nodeset = "bd41df43a8c48495bc7316227aa2ffbefe336c05"
SRCREV_mdnsd = "4bd993e0fdd06d54c8fd0b8f416cda6a8db18585"

SRCREV_FORMAT = "default"

PV = "1.01+git${SRCPV}"

inherit cmake python3native

DEPENDS += "python3-six-native libcheck"

S = "${WORKDIR}/git"

EXTRA_OECMAKE = "-DCMAKE_BUILD_TYPE=RelWithDebInfo -DUA_BUILD_EXAMPLES=1 -DUA_BUILD_UNIT_TESTS=0"

PACKAGECONFIG[sharedlibs] = "-DBUILD_SHARED_LIBS=1,-DBUILD_SHARED_LIBS=0,,"
PACKAGECONFIG[encrypt] = "-DUA_ENABLE_ENCRYPTION=1 -DMBEDTLS_FOLDER_LIBRARY=${STAGING_LIBDIR} -DMBEDTLS_FOLDER_INCLUDE=${STAGING_INCDIR},-DUA_ENABLE_ENCRYPTION=0,mbedtls,"
PACKAGECONFIG[pubsub] = "-DUA_ENABLE_PUBSUB=1,-DUA_ENABLE_PUBSUB=0,,"
PACKAGECONFIG[pubsub_uadp] = "-DUA_ENABLE_PUBSUB_ETH_UADP=1,-DUA_ENABLE_PUBSUB_ETH_UADP=0,,"
PACKAGECONFIG[pubsub_delta_frames] = "-DUA_ENABLE_PUBSUB_DELTAFRAMES=1,-DUA_ENABLE_PUBSUB_DELTAFRAMES=0,,"
PACKAGECONFIG[pubsub_informationmodel] = "-DUA_ENABLE_PUBSUB_INFORMATIONMODEL=1,-DUA_ENABLE_PUBSUB_INFORMATIONMODEL=0,,"
PACKAGECONFIG[pubsub_informationmodel_methods] = "-DUA_ENABLE_PUBSUB_INFORMATIONMODEL_METHODS=1,-DUA_ENABLE_PUBSUB_INFORMATIONMODEL_METHODS=0,,"
PACKAGECONFIG[subscription_events] = "-DUA_ENABLE_SUBSCRIPTIONS_EVENTS=1,-DUA_ENABLE_SUBSCRIPTIONS_EVENTS=0,,"

PACKAGECONFIG[certificate] = "-DUA_BUILD_SELFSIGNED_CERTIFICATE=1,-DUA_BUILD_SELFSIGNED_CERTIFICATE=0,,"

PACKAGECONFIG ?= "pubsub  pubsub_uadp pubsub_delta_frames pubsub_informationmodel \
                  pubsub_informationmodel_methods sharedlibs"

# Install examples
do_install_append() {
    # Install examples
    install -d "${D}${datadir}/${BPN}/examples"
    for example in ${B}/bin/examples/*
    do
        install -m 755 "$example" "${D}${datadir}/${BPN}/examples"
    done
}

PACKAGES =+ "${PN}-examples ${PN}-tests"
FILES_${PN}-dev += "${libdir}/cmake/*"
FILES_${PN}-examples += "${datadir}/${BPN}/examples"

# Allow staticdev package to be empty incase sharedlibs is switched on
ALLOW_EMPTY_${PN}-staticdev = "1"

BBCLASSEXTEND = "native nativesdk"
