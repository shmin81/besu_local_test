#!/bin/bash
# node 1,2를 background에서 실행하고, node 3을 foreground에서 실행
# node 1.2는 다른 스크립트로 중지??

workingDir=$(pwd)
echo $workingDir

#besu config path 
besuConfPath=''
#besuConfPath=./node02/conf2.toml

function checkRunning {
  echo ''
  echo '* check process (Besu --config-file='$besuConfPath')'

  ps -ef | grep "org.hyperledger.besu.Besu --config-file="$besuConfPath | awk '{print $1, $2, $4, $7, $8, $9}'
  echo ''

  ps -ef | grep "org.hyperledger.besu.Besu --config-file="$besuConfPath | awk '{print $2, $7, $8}' > status.txt

  number=`cat status.txt | wc -l`

  let cnt=number-1

  if [ "1" == "$number" ]; then
    echo "besu is not running."
  else
    echo "besu is running... (" $cnt "process)"
  fi
}

checkRunning


echo 'done.'
