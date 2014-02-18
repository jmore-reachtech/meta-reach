do_install_append() {
  #we need this for our info php page
  gunzip ${D}${datadir}/usb.ids.gz
}

PRINC = "1"
