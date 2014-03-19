#!/bin/bash
echo "Must be a ppm file"

ppmquant 9819 $1 > logo_linux_custom_224.ppm

pnmnoraw logo_linux_custom_224.ppm > logo_linux_custom_ascii_224.ppm

exit 0
