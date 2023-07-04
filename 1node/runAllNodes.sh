#!/bin/bash
# node 1,2를 background에서 실행하고, node 3을 foreground에서 실행
# node 1.2는 다른 스크립트로 중지??

clear

workingDir=$(pwd)
echo $workingDir

# echo 'remove old datas'
#rm -rf ./node01/data/*

# 자바 버전 셋팅
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# 실행할 besu 소스코드 위치 
#besuSourcePath=/Users/min/Downloads/besu-git-ref/besu
#besuSourcePath=/Users/min/Downloads/gitlab/besu-client
besuSourcePath=$workingDir/../../../gitlab/besu-client

# 실행할 besu 바이너리 위치 
besuPath=$besuSourcePath/build/install/besu/bin/besu

function chkExexResult {
    if [ $1 -ne 0 ] ; then
        echo 'exit by fail ('$2' -> exitCode:'$1')'
        exit 1
    fi
}

# besu 소스코드를 빌드할 필요가 있을 경우
# cd $besuSourcePath
# ./gradlew installDist
# chkExexResult $? './gradlew installDist'
# cd $workingDir

# clear

## 
echo '\n* Exec besu --version'
$besuPath --version
chkExexResult $? $besuPath

pwd
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"
sleep 1

export BESU_TX_POOL_TX_INFLOW_CONTROL_ENABLED=true
export BESU_TX_POOL_TX_INFLOW_MAX_SIZE=1000
export BESU_TX_POOL_ENTERPRISE_PENDING_TX_SORTER_ENABLED=true
#export BESU_TARGET_GAS_LIMIT=6000000

echo '\n* node1 Exec besu --config-file xxx'
$besuPath --config-file="./node01/conf1.toml"
