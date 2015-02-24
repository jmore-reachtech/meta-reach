#!/bin/bash
echo "################################"
echo "Publishing QML Source"
echo "################################"
mkdir /nand/
/usr/sbin/ubiattach /dev/ubi_ctrl -d 0 -m 1
sleep 1
mount -t ubifs ubi0 /nand/
rm -rf /nand/application/src/* && sync
cp -rf /application/src/* /nand/application/src/ && sync
umount /nand/
ubidetach /dev/ubi_ctrl -m 1
rmdir /nand
echo "################################"
echo "Finished"
echo "################################"
