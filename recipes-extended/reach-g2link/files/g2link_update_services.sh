#!/bin/sh

# this makes the usage line shorter
OPTS="{enable_http|disable_http|enable_samba|disable_samba|enable_ssh|disable_ssh}"

# we need at least one arg
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 $OPTS"
    exit 1
fi

# get the option
CMD=$1

RC_DIR="/etc/rc5.d"
RC_INIT="/etc/init.d"
RP=$(which realpath)

if [ -z "$RP" ]; then
    echo "realpath not found!"
    exit 1
fi

# samba setup
SAMBA_RC=$(ls $RC_DIR | grep samba)
if [ -n "$SAMBA_RC" ]; then
    SAMBA_INIT=$($RP $RC_DIR/$SAMBA_RC)
    SAMBA_RC=$RC_DIR/$SAMBA_RC
else
    SVC=$(ls $RC_INIT | grep samba)
    if [ -z "$SVC" ]; then
        echo "Can not find samba init script"
        exit 1
    fi
    SAMBA_INIT=$RC_INIT/$SVC
    SAMBA_RC=$RC_DIR/S20samba
fi

# lighttpd setup
LIGHTTPD_RC=$(ls $RC_DIR | grep lighttpd)
if [ -n "$LIGHTTPD_RC" ]; then
    LIGHTTPD_INIT=$($RP $RC_DIR/$LIGHTTPD_RC)
    LIGHTTPD_RC=$RC_DIR/$LIGHTTPD_RC
else
    SVC=$(ls $RC_INIT | grep lighttpd)
    if [ -z "$SVC" ]; then
        echo "Can not find lighttpd init script"
        exit 1
    fi
    LIGHTTPD_INIT=$RC_INIT/$SVC
    LIGHTTPD_RC=$RC_DIR/S70lighttpd
fi

# php setup
PHP_RC=$(ls $RC_DIR | grep php)
if [ -n "$PHP_RC" ]; then
    PHP_INIT=$($RP $RC_DIR/$PHP_RC)
    PHP_RC=$RC_DIR/$PHP_RC
else
    SVC=$(ls $RC_INIT | grep php)
    if [ -z "$SVC" ]; then
        echo "Can not find php init script"
        exit 1
    fi
    PHP_INIT=$RC_INIT/$SVC
    PHP_RC=$RC_DIR/S60php-fm
fi

# ssh setup
SSH_RC=$(ls $RC_DIR | grep ssh)
if [ -n "$SSH_RC" ]; then
    SSH_INIT=$($RP $RC_DIR/$SSH_RC)
    SSH_RC=$RC_DIR/$SSH_RC
else
    SVC=$(ls $RC_INIT | grep ssh)
    if [ -z "$SVC" ]; then
        echo "Can not find ssh init script"
        exit 1
    fi
    SSH_INIT=$RC_INIT/$SVC
    SSH_RC=$RC_DIR/S09sshd
fi

# set link command
LN="ln -sf"

# service enable/disable functions
enable_http() {
    echo "enabling http services..."

    $LN $LIGHTTPD_INIT $LIGHTTPD_RC
    $LN $PHP_INIT $PHP_RC

    $LIGHTTPD_INIT restart
    $PHP_INIT restart
}

disable_http() {
    echo "disabling http services..."

    $LIGHTTPD_INIT stop
    $PHP_INIT stop

    rm -f $LIGHTTPD_RC
    rm -f $PHP_RC
}

enable_samba() {
    echo "enabling samba services..."
    $LN $SAMBA_INIT $SAMBA_RC

    $SAMBA_INIT restart
}

disable_samba() {
    echo "disabling samba services..."
    $SAMBA_INIT stop

    rm -f $SAMBA_RC
}

enable_ssh() {
    echo "enabling ssh services..."
    $LN $SSH_INIT $SSH_RC

    $SSH_INIT restart
}

disable_ssh() {
    echo "disabling ssh services..."
    $SSH_INIT stop

    rm -f $SSH_RC
}

# do we have a valid option?
case $CMD in
    enable_http)
        enable_http
    ;;
    disable_http)
        disable_http
    ;;
    enable_samba)
        enable_samba
    ;;
    disable_samba)
        disable_samba
    ;;
    enable_ssh)
        enable_ssh
    ;;
    disable_ssh)
        disable_ssh
    ;;
    *)
        echo "Cmd '$CMD' not supported"
esac
