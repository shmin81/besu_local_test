#!/bin/bash
# node 2,3,4는 background에서 실행하고, node 1을 foreground에서 실행
# node 2,3,4는 다른 스크립트(stopAllNodes.sh)를 이용해 중지 가능

clear

workingDir=$(pwd)
echo $workingDir

echo 'remove old datas'
rm -rf ./node01/data/*
rm -rf ./node02/data/*
rm -rf ./node03/data/*
rm -rf ./node04/data/*

# macOS 자바 버전 셋팅
#export JAVA_HOME=$(/usr/libexec/java_home -v 11)
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export BESU_OPTS=-Xmx1g

# config 파일보다 환경변수로 설정된 값이 우선하여 들어감
export BESU_TX_POOL_TX_INFLOW_CONTROL_ENABLED=true
export BESU_TX_POOL_TX_INFLOW_MAX_SIZE=100
export BESU_TX_POOL_RETENTION_MINUTES=2
export BESU_TX_POOL_ENTERPRISE_PENDING_TX_SORTER_ENABLED=true
export BESU_TX_POOL_LIMIT_BY_ACCOUNT_PERCENTAGE=1.0

# 실행할 besu 소스코드 위치 
#besuSourcePath=/Users/min/Downloads/gitlab/besu-client
#besuSourcePath=/Users/min/Downloads/github-utils/besu-client-tmp
besuSourcePath=$workingDir/../../../gitlab/besu-client
#besuSourcePath=$workingDir/../../../github-utils/besu-client-tmp

#Check Requirement
if ! [ -e $besuSourcePath ] ; then
	echo "[Error] '$besuSourcePath' directory does not exist."
	exit 1
fi

# besu 소스코드를 빌드할 필요가 있을 경우
cd $besuSourcePath
./gradlew installDist
cd $workingDir

# 실행할 besu 바이너리 위치 
besuPath=$besuSourcePath/build/install/besu/bin/besu

echo '\n* Exec besu --version'
$besuPath --version
exitCode=$?
if [ $exitCode -ne 0 ] ; then
    echo 'exit by fail ('$besuPath' --version -> exitCode:'$exitCode')'
    exit 1
fi

echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"
echo  workingDir: $workingDir
sleep 3

echo '\n* node4 Exec besu --config-file xxx'
nohup $besuPath --config-file="./node04/conf4.toml" > node04.log 2>&1 &

echo '\n* node3 Exec besu --config-file xxx'
nohup $besuPath --config-file="./node03/conf3.toml" > node03.log 2>&1 &

echo '\n* node2 Exec besu --config-file xxx'
nohup $besuPath --config-file="./node02/conf2.toml" > node02.log 2>&1 &

echo '\n* node1 Exec besu --config-file xxx'
$besuPath --config-file="./node01/conf1.toml"
