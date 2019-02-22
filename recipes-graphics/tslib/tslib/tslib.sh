#!/bin/sh

if [ -e /dev/input/event0 ]; then
    TSLIB_TSDEVICE=/dev/input/event0

    export TSLIB_TSDEVICE
fi

