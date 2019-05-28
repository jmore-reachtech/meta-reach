#!/bin/sh

SRC_PATH="/run/media/sda1/app"
TARGET_PATH="/data/app"
QML_APP="/etc/init.d/qmlapp"
FB_BLANK="/sys/class/graphics/fb0/blank"

if [ ! -d ${SRC_PATH} ]
then
        echo "Upgrade source not found! Please check USB stick."
        exit 1
fi

echo "Using upgrade source ${SRC_PATH}"

echo "Blanking the panel"

echo 1 > ${FB_BLANK}

echo "Terminating Qml Viewer"

${QML_APP} stop

if [ -d ${TARGET_PATH}.old ]
then
        rm -rf ${TARGET_PATH}.old
fi

echo "Backup current app"

mv ${TARGET_PATH} ${TARGET_PATH}.old

echo "Copy new Qml app"

cp -r ${SRC_PATH} ${TARGET_PATH}

echo "Syncing filesystem"

sync && sync

echo "Rebooting system"

reboot
