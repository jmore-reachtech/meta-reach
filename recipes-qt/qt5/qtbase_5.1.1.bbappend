##hacks, each hackier than the next
PACKAGECONFIG[gles2] = "-opengl es2,,virtual/libgles2 virtual/egl"
PACKAGECONFIG[eglfs] = "-eglfs,-no-eglfs,eglfs"

FILESEXTRAPATHS_prepend := "${THISDIR}/{PN}{PV}:"

SCR_URI += "\
  file://Force_egl_visual_ID_33.patch \
"

PRINC = "1"
