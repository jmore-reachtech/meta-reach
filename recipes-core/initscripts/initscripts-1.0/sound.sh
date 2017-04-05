#!/bin/sh

SOUND="$(cat /proc/asound/cards)"     

case "$1" in
  start)
    if [[ "$SOUND" =~ "no soundcards" ]]; then
        echo "Loading dummy sound module."    
        modprobe snd_dummy;   
    fi
    ;;
  stop)
    if [[ "$SOUND" =~ "no soundcards" ]]; then
        echo "Unloading dummy sound module."    
        modprobe -r snd_dummy;   
    fi
	;;
  restart)
	$0 stop
	$0 start
	;;
  *)
	echo "usage: $0 { start | stop | restart }" >&2
	exit 1
	;;
esac

exit 0
