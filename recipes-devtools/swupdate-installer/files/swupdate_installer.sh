#!/bin/sh

/usr/bin/clear

/usr/bin/psplash &

SWUPDATE_IMAGE="swupdate-image-g2h-solo-3.mmc.swu"
PROGRESS=0
COMPLETE=0
USB_DEV=/dev/sda1

increment_progress() {
        PROGRESS=$(expr ${PROGRESS} + $1)
}

set_progress() {
    /usr/bin/psplash-write "PROGRESS ${PROGRESS}"
    /usr/bin/psplash-write "MSG $1"
}

process_file_list() {
    increment_progress "10"
    set_progress "Processing image list"

    if [ -n "${IMAGE_LIST}" ]
    then
        for f in ${IMAGE_LIST}
        do
            sleep 3
            DEVICE_TYPE=$(echo $f | awk -F "." '{print $1}')
            DEVICE_ENTRY=$(echo $f | awk -F "." '{print $2}')
            IMAGE_TYPE=$(echo $f | awk -F "." '{print $3}')

            increment_progress "20"
            set_progress "Installing ${IMAGE_TYPE}"
        done
    else
        clean_up "Update Image List Empty"
    fi
}

setup_work_dir() {
    increment_progress "10"
    set_progress "Setup update"
    
    cd /tmp/

    mkdir -p swupdate
    
    if [ -b "${USB_DEV}" ]
    then
        mount "${USB_DEV}" ./swupdate/

        cd swupdate/

        export TOP_DIR=$(pwd)

        export WORK_DIR=$(mktemp -d -p ${TOP_DIR})  
    else
        clean_up "USB Device Not Found"
    fi
}

extract_update() {
    cd ${WORK_DIR}

    increment_progress "10"
    set_progress "Extracting update image"
    
    if [ -f "${TOP_DIR}/${SWUPDATE_IMAGE}" ]
    then
        cpio --extract -F ${TOP_DIR}/${SWUPDATE_IMAGE}
    else
        clean_up "Update Image Not Found"
    fi

    export IMAGE_LIST=$(ls ${WORK_DIR} | sed 's/\n//g')
}

clean_up() {
    sleep 2

    if [ "1" == "$COMPLETE" ]
    then
        /usr/bin/psplash-write "QUIT"
    else
        set_progress "$1, Please cycle power"
        read -p "$1"
    fi

    cd ${TOP_DIR}

    rm -rf ${WORK_DIR}

    cd /tmp

    mount | grep ${USB_DEV} > /dev/null && umount ${USB_DEV} || echo "${USB_DEV} not mounted"

    if [ -d ./swupdate ]
    then
        rmdir ./swupdate
    fi

    exit 0
}

setup_work_dir

extract_update

process_file_list

COMPLETE=1
PROGRESS=100

set_progress "Rebooting, please wait"
clean_up
