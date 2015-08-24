#!/bin/bash 
 
### BEGIN INIT INFO
# Provides: expensable_ping
# Required-Start: 
# Required-Stop: 
# Should-Start: 
# Should-Stop: 
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start and stop expensable ping
# Description: Expensable
### END INIT INFO

LOG=/tmp/expensable4.log 
SECONDS=3600 
HOST=expensable4.herokuapp.com

while true; do 
  ping -c 1 $HOST > /dev/null 
  if [ $? -ne 0 ]; then 
    echo "DOWN!" > $LOG 
  fi 
  sleep $SECONDS 
done 
