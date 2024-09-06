#!/bin/bash
clear
workingDir=$(pwd)
echo $workingDir
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"

shell=bash
# echo 'remove old datas'
#rm -rf ./node01/data/*

# 자바 셋팅
#export JAVA_HOME="/sw/openjdk/17.0.9"
#export PATH=$JAVA_HOME/bin:$PATH

export BESU_OPTS="-Xmx2g"
#export BESU_OPTS="-Xmx2g -Xms1g "
#export JAVA_OPTS="-Dwhatap.micro.enabled=true "
#export LOG4J_CONFIGURATION_FILE=./log4j_conf.xml

# config 파일보다 환경변수로 설정된 값이 우선하여 들어감
#export BESU_METRICS_ENABLED=true
export BESU_TX_POOL_RETENTION_MINUTES=2
# export BESU_TX_POOL_TX_INFLOW_CONTROL_ENABLED=true
# export BESU_TX_POOL_TX_INFLOW_MAX_PERCENTAGE=0.5
# export BESU_TX_POOL_TX_INFLOW_MAX_SIZE=100 (deprecated)
# export BESU_TX_POOL_ENTERPRISE_PENDING_TX_SORTER_ENABLED=true
# export BESU_TX_POOL_TX_FAST_VERIFY_SIGNATURE_ENABLED=true
# export BESU_PERF_ELIMINATE_REDUNDANT_BLOCK_VALIDATION_ENABLED=true

export BESU_TX_POOL=legacy
export BESU_RPC_HTTP_MAX_ACTIVE_CONNECTIONS=1000
export BESU_TX_POOL_MAX_SIZE=10000
export BESU_TX_POOL_LIMIT_BY_ACCOUNT_PERCENTAGE=1.0

# 실행할 besu 소스코드 위치 
#besuSourcePath=$workingDir/../../../gitlab/besu-client
besuSourcePath=$workingDir/../../../github-utils/besu-client-tmp

#Check Requirement
if ! [ -e $besuSourcePath ] ; then
	echo "[Error] '$besuSourcePath' directory does not exist."
	exit 1
fi

# 실행할 besu 바이너리 위치 
besuPath=$besuSourcePath/build/install/besu/bin/besu
# besuPath=besu

function chkExexResult {
    if [ $1 -ne 0 ] ; then
        echo 'exit by fail ('$2' -> exitCode:'$1')'
        exit 1
    fi
}

echo '\n* Exec besu --version'
$besuPath --version
chkExexResult $? $besuPath

# besu가 이미 실행 중이면, 스크립트 종료
$shell ../common/chkBesuStatus.sh "./node01/conf1.toml"
chkExexResult $? 'check besu process'
sleep 2

echo '\n* node1 Exec besu --config-file xxx'
$besuPath --config-file="./node01/conf1.toml"
