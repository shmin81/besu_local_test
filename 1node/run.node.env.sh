#!/bin/bash
clear
workingDir=$(pwd)
echo $workingDir

# echo 'remove old datas'
#rm -rf ./node01/data/*

# macOS 자바 버전 셋팅
#export JAVA_HOME=$(/usr/libexec/java_home -v 11)
#export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export BESU_OPTS=-Xmx2g

# config 파일보다 환경변수로 설정된 값이 우선하여 들어감
export BESU_TX_POOL_TX_INFLOW_CONTROL_ENABLED=true
export BESU_TX_POOL_TX_INFLOW_MAX_SIZE=100
export BESU_TX_POOL_RETENTION_MINUTES=2
export BESU_TX_POOL_ENTERPRISE_PENDING_TX_SORTER_ENABLED=true
export BESU_TX_POOL_TX_FAST_VERIFY_SIGNATURE_ENABLED=true
export BESU_PERF_ELIMINATE_REDUNDANT_BLOCK_VALIDATION_ENABLED=true
#######################################
export BESU_RPC_HTTP_MAX_ACTIVE_CONNECTIONS=1000
export BESU_TX_POOL_MAX_SIZE=1000
export BESU_TX_POOL_LIMIT_BY_ACCOUNT_PERCENTAGE=1.0
#export BESU_RPC_HTTP_API=ETH,NET,WEB3,TXPOOL,DEBUG,ADMIN

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

pwd
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"
echo  workingDir: $workingDir
sleep 3

echo '\n* node1 Exec besu --config-file xxx'
$besuPath --config-file="./node01/conf1.toml"
