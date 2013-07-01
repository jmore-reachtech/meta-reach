#!/bin/sh

ppmquant 224 $1 > logo.ppm
pnmnoraw logo.ppm > logo_ascii.ppm

gdk-pixbuf-csource --macros logo_ascii.ppm > logo.tmp

sed -e "s/MY_PIXBUF/POKY_IMG/g" -e "s/guint8/uint8/g" logo.tmp > psplash-poky-img.h && rm logo.tmp && rm logo_ascii.ppm && rm logo.ppm

echo "done"


