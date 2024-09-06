#!/bin/bash

workingDir=$(pwd)
echo $workingDir
pid=''

#besu config path 
BESU_CONFIG=$1
echo "check keyword: '$BESU_CONFIG'"

check_process() {
  ps aux | grep -v grep | grep "org.hyperledger.besu.Besu" | grep "$BESU_CONFIG" > /dev/null 2>&1
}

get_pid() {
  #ps -ef | grep -v grep | grep "$BESU_CONFIG"
  pid=$(ps aux | grep -v grep | grep "org.hyperledger.besu.Besu" | grep "$BESU_CONFIG" | awk '{print $2}')
}

function checkRunning {

  if check_process; then
    get_pid
    echo "besu is running. (pid: $pid)"
    exit 1
  else
    echo "besu is not running."
    exit 0
  fi
}

checkRunning
