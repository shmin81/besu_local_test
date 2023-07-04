#!/bin/bash
# node 1,2를 background에서 실행하고, node 3을 foreground에서 실행
# node 1.2는 다른 스크립트로 중지??

clear

workingDir=$(pwd)
echo $workingDir

# 자바 버전 셋팅
#export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# 실행할 besu 소스코드 위치 
#besuSourcePath=/Users/????/Downloads/gitlab/besu-client
besuSourcePath=$workingDir/../../gitlab/besu-client

# 실행할 besu 바이너리 위치 
besuPath=$besuSourcePath/build/install/besu/bin/besu

function chkExexResult {
    if [ $1 -ne 0 ] ; then
        echo 'exit by fail ('$2' -> exitCode:'$1')'
        exit 1
    fi
}

## 
echo '\n* Exec besu --version'
$besuPath --version
chkExexResult $? $besuPath

pwd
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"
sleep 1


echo '\n* Exec besu '
$besuPath operator generate-blockchain-config --config-file=genesis_IBFT2_Input.json --to=./1node/outX 
