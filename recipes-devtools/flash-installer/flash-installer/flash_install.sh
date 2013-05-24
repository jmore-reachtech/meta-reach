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
    fi

    if [ "$DRY_RUN" == "no" ]
    then
        /usr/sbin/flash_erase $DEV_ENTRY 0 0
        /usr/sbin/ubiattach /dev/ubi_ctrl -d 0 -m $UBI_MTD_NUM
        /usr/sbin/ubimkvol /dev/ubi0 -N rootfs0 -m
        /usr/sbin/ubiupdatevol /dev/ubi0_0 $SRC_FNAME
        /usr/sbin/ubidetach /dev/ubi_ctrl -m $UBI_MTD_NUM
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
        #/usr/sbin/flash_write -q -p $DEV_ENTRY $SRC_FNAME
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

           case $IMAGE_TYPE in
               "ubifs" )
                   process_ubifs $file $DEVICE_TYPE $DEVICE_ENTRY
                   ;;
               "bin" )
                   process_bin $file $DEVICE_TYPE $DEVICE_ENTRY
                   ;;
               "sb" )
                   process_sb $file $DEVICE_TYPE $DEVICE_ENTRY
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
