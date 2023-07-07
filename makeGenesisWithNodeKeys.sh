#!/bin/bash
clear

workingDir=$(pwd)
echo 'Working Dir: '$workingDir

##########################################
consensus=IBFT
#consensus=QBFT
##########################################
echo 'Consensus Algorithm : '$consensus
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

function chkPathResult {
    if ! [ -e $1 ] ; then
        echo "[Error] '$1' does not exist."
        exit 1
    fi
}

configPath='genesis_'$consensus'_Input.json'
chkPathResult $configPath

## 
echo '\n* Exec besu --version'
$besuPath --version
chkExexResult $? $besuPath

sleep 3

echo '\n* Exec: besu operator generate-blockchain-config ' --config-file=$configPath --to='./out'$consensus
$besuPath operator generate-blockchain-config --config-file=$configPath --to='./out'$consensus
