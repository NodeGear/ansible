#!/bin/sh

### BEGIN INIT INFO
# Provides:          nodegear_git
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: NG Git Deamon
# Description:       NG Git Daemon
### END INIT INFO

. /etc/rc.d/init.d/functions

DIR=/root/ng-git/
DAEMON=$DIR/bin/ng-git.js
DAEMON_NAME=nodegear_git
DAEMON_USER=root
PIDFILE=/var/run/$DAEMON_NAME.pid

export NODE_ENV=production

do_start () {
    log_daemon_msg "Starting system $DAEMON_NAME daemon"
    start-stop-daemon --start --background \
	--pidfile $PIDFILE --make-pidfile \
	--user $DAEMON_USER --chuid $DAEMON_USER \
	--startas $DAEMON
    log_end_msg $?
}

do_stop () {
    log_daemon_msg "Stopping $DAEMON_NAME daemon"
    start-stop-daemon --stop --pidfile $PIDFILE --retry 10
    log_end_msg $?
}

case "$1" in

    start|stop)
        do_${1}
        ;;

    restart|reload|force-reload)
        do_stop
        do_start
        ;;

    status)
        status_of_proc "$DAEMON_NAME" "$DAEMON" && exit 0 || exit $?
        ;;
    *)
        echo "Usage: /etc/init.d/$DAEMON_NAME {start|stop|restart|status}"
        exit 1
        ;;

esac
exit 0