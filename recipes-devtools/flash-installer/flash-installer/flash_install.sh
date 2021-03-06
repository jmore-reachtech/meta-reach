#!/bin/sh


#  Setup operating variables.
#
IMAGE_DIR=/images
IMAGE_LIST=`ls  $IMAGE_DIR | sed 's/\n//g'`
VERBOSE_FLAG="no"
DRY_RUN="no"

dumpVariables() {

    echo "Root:       $ROOT_DIR"
    echo "Images:     $IMAGE_DIR"
    if [ -n "$IMAGE_LIST" ]
    then
        echo "Image List: <$IMAGE_LIST>"
    else
        echo "Image List: Empty"
    fi

    if [ "$DRY_RUN" == "yes" ]
    then
        echo "==="
        echo "This is a Dry Run"
        echo "==="
    fi

}

process_ubifs() {

    SRC_FNAME=$IMAGE_DIR/$1
    FS_NAME=$4

    if [ -z "$FS_NAME" ]; then
		FS_NAME="rootfs0"
    fi

    case $DEVICE_TYPE in
        "mtd" )
            DEV_ENTRY="/dev/mtd$3"
            UBI_MTD_NUM=$3
            ;;
        "*" )
            DEV_ENTRY="unknown"
            ;;
    esac

    if [ "$VERBOSE_FLAG" == "yes" ]
    then
        echo "process_ubifs(): Filename <$SRC_FNAME>"
        echo "process_ubifs(): Device Type <$2>, Device Entry <$3>"
        echo "process_ubifs(): Device Entry <$DEV_ENTRY>"
        echo "process_ubifs(): FS Name <$4>"
    fi

    if [ "$DRY_RUN" == "no" ]
    then
        /usr/sbin/ubiformat $DEV_ENTRY -s 2048 -y
        sleep 2
        /usr/sbin/ubiattach /dev/ubi_ctrl -d 0 -m $UBI_MTD_NUM
        sleep 2
        /usr/sbin/ubimkvol /dev/ubi0 -N $FS_NAME -m
        sleep 2
        /usr/sbin/ubiupdatevol /dev/ubi0_0 $SRC_FNAME
        sleep 2
        /usr/sbin/ubidetach /dev/ubi_ctrl -m $UBI_MTD_NUM
        sleep 2
   fi

}

process_bin() {

    SRC_FNAME=$IMAGE_DIR/$1

    case $DEVICE_TYPE in
        "mtd" )
            DEV_ENTRY="/dev/mtd$3"
            ;;
        "*" )
            DEV_ENTRY="unknown"
            ;;
    esac

    if [ "$VERBOSE_FLAG" == "yes" ]
    then
        echo "process_bin(): Filename <$SRC_FNAME>"
        echo "process_bin(): Device Type <$2>, Device Entry <$3>"
        echo "process_bin(): Device Entry <$DEV_ENTRY>"
    fi

    if [ "$DRY_RUN" == "no" ]
    then
        /usr/sbin/flash_erase $DEV_ENTRY 0 0
        dd of=$DEV_ENTRY if=$SRC_FNAME
    fi
}
process_bin_imx() {

    SRC_FNAME=$IMAGE_DIR/$1

    case $DEVICE_TYPE in
        "mtd" )
            DEV_ENTRY="/dev/mtd$3"
            ;;
        "*" )
            DEV_ENTRY="unknown"
            ;;
    esac

    if [ "$VERBOSE_FLAG" == "yes" ]
    then
        echo "process_bin_imx(): Filename <$SRC_FNAME>"
        echo "process_bin_imx(): Device Type <$2>, Device Entry <$3>"
        echo "process_bin_imx(): Device Entry <$DEV_ENTRY>"
    fi

    if [ "$DRY_RUN" == "no" ]
    then
        /usr/sbin/flash_erase $DEV_ENTRY 0 0
        dd of=$DEV_ENTRY if=$SRC_FNAME bs=512 seek=2
    fi
}

process_bin_nand() {

    SRC_FNAME=$IMAGE_DIR/$1

    case $DEVICE_TYPE in
        "mtd" )
            DEV_ENTRY="/dev/mtd$3"
            ;;
        "*" )
            DEV_ENTRY="unknown"
            ;;
    esac

    if [ "$VERBOSE_FLAG" == "yes" ]
    then
        echo "process_bin_nand(): Filename <$SRC_FNAME>"
        echo "process_bin_nand(): Device Type <$2>, Device Entry <$3>"
        echo "process_bin_nand(): Device Entry <$DEV_ENTRY>"
    fi

    if [ "$DRY_RUN" == "no" ]
    then
        /usr/sbin/flash_erase $DEV_ENTRY 0 0
        nandwrite -p $DEV_ENTRY $SRC_FNAME
    fi
}


process_sb() {

    SRC_FNAME=$IMAGE_DIR/$1

    case $DEVICE_TYPE in
        "mtd" )
            #  Hard code to /dev/mtd0 for now, as the kobs-ng
            #  works on that partition, and it's the only
            #  partition to boot i.mx28 from.
            #
            DEV_ENTRY="/dev/mtd0"
            ;;
        "*" )
            DEV_ENTRY="unknown"
            ;;
    esac

    if [ "$VERBOSE_FLAG" == "yes" ]
    then
        echo "process_sb(): Filename <$SRC_FNAME>"
        echo "process_sb(): Device Type <$2>, Device Entry <$3>"
        echo "process_sb(): Device Entry <$DEV_ENTRY>"
    fi

    if [ "$DRY_RUN" == "no" ]
    then
        /usr/sbin/flash_erase $DEV_ENTRY 0 0
        /usr/bin/kobs-ng init $SRC_FNAME
    fi
}


processFileList() {

    if [ -n "$IMAGE_LIST" ]
    then
       for file in $IMAGE_LIST
       do
           DEVICE_TYPE=`echo $file | awk -F . '{print $1}'`
           DEVICE_ENTRY=`echo $file | awk -F . '{print $2}'`
           IMAGE_TYPE=`echo $file | awk -F . '{print $3}'`
           UBIFS_NAME=`echo $file | awk -F . '{print $4}'`

           case $IMAGE_TYPE in
               "ubifs" )
                   process_ubifs $file $DEVICE_TYPE $DEVICE_ENTRY $UBIFS_NAME
                   ;;
               "bin" )
                   process_bin $file $DEVICE_TYPE $DEVICE_ENTRY
                   ;;
               "sb" )
                   process_sb $file $DEVICE_TYPE $DEVICE_ENTRY
                   ;;
               "imx" )
                   process_bin_imx $file $DEVICE_TYPE $DEVICE_ENTRY
                   ;;
               "nand" )
                   process_bin_nand $file $DEVICE_TYPE $DEVICE_ENTRY
                   ;;
               "*" )
                   echo "processFileList(): Unknown Type <$IMAGE_TYPE>, igonore"
                   ;;
           esac
       done
    else
        echo "Image List: Empty"
    fi


}


#  Entry Point.
#
while getopts "vd" opt
do
  case $opt in
    v )
      VERBOSE_FLAG="yes"
      ;;
    d )
      DRY_RUN="yes"
      ;;
    * )
      echo "Invalid option: -$opt" >&2
      ;;
  esac
done

if [ "$VERBOSE_FLAG" == "yes" ]
then
    dumpVariables
fi

#  Process list of files in <images> directory"
#
processFileList
