#!/bin/sh

checkUser() {
  if [ "`whoami`" != "admin" ]; then
   echo "You need admin to run this script"
   exit 1
  fi
}
#checkUser

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

CMD_PATH=`dirname $0`
CMD_HOME=`cd "$CMD_PATH"/../; pwd`

APP_NAME=tengine
APP_HOME=`dirname $CMD_HOME`
SUPERVISORD_BIN=$(which supervisord)
SUPERVISORCTL_BIN=$(which supervisorctl)
SUPERVISORD_CONF=${CMD_HOME}/conf/supervisor.conf
SUPERVISORD_PIDFILE=$(grep pidfile $SUPERVISORD_CONF |grep supervisord |awk -F '=' '{print $2}')

# Source function library.
. /etc/init.d/functions

check_init() {
  if [ ! -d $APP_HOME ]; then
    echo -n "$APP_HOME is not exists."; echo_failure; echo
    exit 1
  fi

  if [ ! -f $SUPERVISORD_CONF ]; then
    echo -n "$SUPERVISORD_CONF is not exists."; echo_failure; echo
    exit 1
  fi
}

app_start() {
  check_init
  echo -n "Starting $APP_NAME "
  if [ -f "$SUPERVISORD_PIDFILE" ]; then
    if kill -0 `cat "$SUPERVISORD_PIDFILE"` > /dev/null 2>&1; then
      echo -e "already running as process" `cat "$SUPERVISORD_PIDFILE"`
      ret=$?
      [ $ret -eq 0 ] && success || failure; echo
      exit 0
    fi
  fi
  $SUPERVISORD_BIN -c $SUPERVISORD_CONF
  ret=$?
  [ $ret -eq 0 ] && success || failure; echo
}

app_stop() {
  check_init
  echo -n "Stopping $APP_NAME "
  $SUPERVISORCTL_BIN -c $SUPERVISORD_CONF shutdown
  ret=$?
  [ $ret -eq 0 ] && success || failure; echo
}

app_restart() {
  check_init
  app_pid=`cat "$SUPERVISORD_PIDFILE" 2>/dev/null`
  if [ -n "$app_pid" ] && ps -p $app_pid > /dev/null 2>&1; then
    app_stop
    waitting 10
  fi
  app_start
}

app_status() {
  check_init
  status -p "$SUPERVISORD_PIDFILE" "$APP_NAME" "$APP_NAME"
}

waitting() {
  local seconds=$1
  for i in `seq 1 $seconds`; do
    sleep 1
    ((exptime++))
    echo -n -e "\rWaitting: $exptime..."
  done
  echo -n -e "\n"
}

case "$1" in
  start)
    app_start
    ;;

  stop)
    app_stop
    ;;

  restart)
    app_restart
    ;;

  status)
    app_status
    ;;

  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;

esac

