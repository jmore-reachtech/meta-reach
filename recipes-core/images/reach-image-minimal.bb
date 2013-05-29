include recipes-core/images/core-image-minimal.bb

IMAGE_INSTALL += "\
	packagegroup-custom-dev-tools \
	packagegroup-custom-core \
"

export IMAGE_BASENAME = "reach-image-minimal"

