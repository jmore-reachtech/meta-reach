include recipes-core/images/core-image-minimal.bb


IMAGE_INSTALL = "\
	${CORE_IMAGE_BASE_INSTALL} \
	packagegroup-custom-dev-tools \
	packagegroup-custom-core \
	tslib \
	tslib-calibrate \
	tslib-tests \
	tsinit \
"

export IMAGE_BASENAME = "reach-image-minimal"
