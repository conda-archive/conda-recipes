#!/bin/bash
#
# Disco	     This starts and stops the disco master node.
#            Runlevels 2, 3, 5 and start/kill 80
#
#            
# chkconfig: 235 80 80
#
# 

# Source function library.
. /etc/init.d/functions

BIN=$PREFIX/bin

KEYGEN=/usr/bin/ssh-keygen
KEYSCAN=/usr/bin/ssh-keyscan

RSA_KEY=$PREFIX/var/disco/.ssh/id_rsa
AUTHORIZED_KEYS=$PREFIX/var/disco/.ssh/authorized_keys

SSHD_KEY=/etc/ssh/ssh_host_rsa_key.pub
KNOWN_HOSTS=$PREFIX/var/disco/.ssh/known_hosts

export PATH="$BIN:$PATH"

[ -x ${BIN}/disco ] || exit 5

## Reuse the debian named logging functions
log_success_msg() {
	echo -n $*
	echo_success
	echo
}

log_failure_msg() {
	echo -n $*
	echo_failure
	echo
}

log_daemon_msg() {
	echo -n $*
	echo_failure 
	echo
}

# From sshd
do_rsa_keygen() {
        if [ ! -s $RSA_KEY ]; then
                echo -n $"Generating SSH2 RSA host key: "
                rm -f $RSA_KEY
                if test ! -f $RSA_KEY && $KEYGEN -q -t rsa -f $RSA_KEY -C '' -N '' >&/dev/null; then
                        chmod 600 $RSA_KEY
                        chmod 644 $RSA_KEY.pub

                        # Modify for Disco
                        chown disco:disco $RSA_KEY
                        chown disco:disco $RSA_KEY.pub
    
                        # Setup Authorized key
                        cp $RSA_KEY.pub $AUTHORIZED_KEYS
                        chown disco:disco $AUTHORIZED_KEYS

                        if [ -x /sbin/restorecon ]; then
                            /sbin/restorecon $RSA_KEY.pub
                        fi
                        log_success_msg ""
                else
                        log_failure_msg ""
                        exit 1
                fi
        fi
}

do_known_hosts() {
	if [ ! -s $KNOWN_HOSTS ]; then
		echo -n $"Creating Known Hosts file: "
		# Setup known_hosts
		$KEYSCAN localhost >  $KNOWN_HOSTS  2>/dev/null
		
		# Amazon requires hashed hostnames in KNOWN HOSTS
		$KEYGEN -H -f $KNOWN_HOSTS &>/dev/null
		rm $KNOWN_HOSTS.old

		chown disco:disco $KNOWN_HOSTS
		log_success_msg $""
	fi
}

running() {
    runuser -s /bin/bash disco -c "${BIN}/disco status" | grep -q running
    errcode=$?
    return $errcode
}

start_server() {
    do_rsa_keygen
    do_known_hosts
    runuser -s /bin/bash disco -c "${BIN}/disco start" &>/dev/null
    errcode=$?
	return $errcode
}

stop_server() {
    runuser -s /bin/bash disco -c "${BIN}/disco stop"
    errcode=$?
	return $errcode
}

restart_server() {
    ${BIN}/disco restart
    errcode=$?
    return $errcode
}

case "$1" in
  start)
        if running ;  then
            log_success_msg "disco-master already running"
            exit 0
        fi
        if start_server ; then
            log_success_msg "disco-master started"
            exit 0
        else
            log_failure_msg "disco-master couldn't be started"
            exit 1
        fi
	;;
  stop)
        if running ; then
            if stop_server ; then
                log_success_msg "Disco stopped"
                exit 0
            else
                log_failure_msg "Couldn't stop Disco"
                exit 1
            fi
        else
            log_daemon_msg "Disco is not running."
            exit 0
        fi
        ;;
  restart|force-reload)
        if restart_server ; then
            log_success_msg "Success"
            exit 0
        else
            log_failure_msg "Failure"
            exit 1
        fi
	;;
  status)
        if running ;  then
            echo  "disco-master running"
            exit 0
        else
            echo  "disco-master stopped"
            exit 3
        fi
        ;;
  *)
	echo "Usage: $0 {start|stop|restart|force-reload|status}" >&2
	exit 3
	;;
esac
