#!/bin/bash
echo "################################"
echo "Publishing Source"
echo "################################"
mkdir /nand/
/usr/sbin/ubiattach /dev/ubi_ctrl -d 0 -m 1
sleep 1
mount -t ubifs ubi0 /nand/
sleep 1

if [ -d "/Crank" ] && [ -d "/nand/Crank" ]; then
  echo "SRC found for Crank Software"
elif [ ! -d "/Crank" ] && [ ! -d "/nand/Crank" ]; then
  echo "SRC found for QML"
else
  echo "##############################################"
  echo "SRC is different on NAND. Restore NAND first."
  echo "##############################################"
  return 1
fi

rm -rf /nand/application/src/* && sync
cp -rf /application/src/* /nand/application/src/ && sync
umount /nand/
ubidetach /dev/ubi_ctrl -m 1
rmdir /nand
echo "################################"
echo "Finished"
echo "################################"
