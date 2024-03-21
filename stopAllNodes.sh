#!/bin/bash
# node 1,2를 background에서 실행하고, node 3을 foreground에서 실행
# node 1.2는 다른 스크립트로 중지??

workingDir=$(pwd)
echo $workingDir

function checkRunning {
  echo ''
  echo '* check besu process'
  ps -ef | grep "org.hyperledger.besu.Besu --config-file=" | awk '{print $2, $7, $8}' > status.txt

  number=`cat status.txt | wc -l`

  if [ "1" == "$number" ]; then
    echo "besu is not running."
    echo 'done.'
    exit 0
  else
    echo "besu is running..."
  fi
}

checkRunning

echo ''
echo '* stopping... besu process'
#ps -ef | grep "org.hyperledger.besu.Besu --config-file=" | awk '{print $2}' | xargs kill
ps -ef | grep "org.hyperledger.besu.Besu --config-file=" | awk '{ if ( $8 != "grep") print ($2) }' | xargs kill

sleep 2

checkRunning

echo 'done.'
