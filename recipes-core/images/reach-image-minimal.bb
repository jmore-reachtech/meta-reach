include recipes-core/images/core-image-minimal.bb

IMAGE_INSTALL += "\
	packagegroup-custom-dev-tools \
"

export IMAGE_BASENAME = "reach-image-minimal"

