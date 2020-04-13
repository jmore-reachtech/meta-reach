#! /bin/sh
#		levels	start	kill
#===================================
# chkconfig:	345	30	30
# description:	pulseaudio sound mixing daemon

# Yocto init.d script for pulseaudio
# Copyright © 2020 Reach Technology

# set -e

# Source function library.
. /etc/init.d/functions

DAEMON=/usr/bin/pulseaudio
NAME=pulseaudio
PIDFILE=/var/run/pulse/pid
DESC="pulseaudio sound daemon"
OPTIONS="-D --system --log-target=syslog --realtime --use-pid-file --disallow-module-loading --disallow-exit"

test -x $DAEMON || exit 0

light_it_off()
{
  if [ -e $PIDFILE ]; then
    PIDDIR=/proc/$(cat $PIDFILE)
    if [ -d ${PIDDIR} -a  "$(readlink -f ${PIDDIR}/exe)" = "${DAEMON}" ]; then
      echo "$DESC already started; not starting."
    else
      echo "Removing stale PID file $PIDFILE."
      rm -f $PIDFILE
    fi
  fi

  if [ -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
    eval `/usr/bin/dbus-launch --auto-syntax`
  fi

  echo -n "Starting $DESC: "
  ${DAEMON} ${OPTIONS}
  echo "$NAME."
}

snuff_it_out()
{
  if [ -e $PIDFILE ]; then
    echo -n "Stopping $DESC: "
    /bin/kill -TERM $(cat $PIDFILE)
    rm -rf $(dirname $PIDFILE)
    echo "$NAME."
  else
    echo "$DESC is not running."
  fi
}

case "$1" in
  start)
    light_it_off
  ;;
  stop)
    snuff_it_out
  ;;
  status)
    status $DAEMON
    exit $?
  ;;
  restart)
    snuff_it_out
    sleep 1
    light_it_off
  ;;
  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|status|restart|}" >&2
    exit 1
  ;;
esac

exit 0
