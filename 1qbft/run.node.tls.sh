#!/bin/bash
clear
workingDir=$(pwd)
echo $workingDir

# echo 'remove old datas'
#rm -rf ./node01/data/*

# 실행할 besu 소스코드 위치 
#besuSourcePath=$workingDir/../../../gitlab/besu-client
#besuSourcePath=$workingDir/../../../github-utils/besu-client-tmp
#besuSourcePath=$workingDir/../../besu-binary/23.10.2
#besuSourcePath=$workingDir/../../besu-binary/23.10.3-hotfix
#besuSourcePath=$workingDir/../../besu-binary/24.1.1
#besuSourcePath=$workingDir/../../besu-binary/23.1.3.2
besuSourcePath=/home/cogod144/gitlab/besu-client

# 실행할 besu 바이너리 위치 
besuPath=$besuSourcePath/build/install/besu/bin/besu
#besuPath=$besuSourcePath/bin/besu
# besuPath=besu

besuConfPath=./node01/conf1_tls.toml

#=============================
#export LOG4J_CONFIGURATION_FILE=./log4j_conf.xml
#export BESU_IDENTITY="val01"

export BESU_OPTS="-Xmx1g"
#export BESU_OPTS="-Xmx2g -Xms1g "
#export JAVA_OPTS="-Dwhatap.micro.enabled=true "

#export BESU_METRICS_ENABLED=true
export BESU_METRICS_HOST=0.0.0.0
# config 파일보다 환경변수로 설정된 값이 우선하여 들어감
export BESU_TX_POOL_TX_INFLOW_CONTROL_ENABLED=true
export BESU_TX_POOL_TX_INFLOW_MAX_PERCENTAGE=0.5
# export BESU_TX_POOL_TX_INFLOW_MAX_SIZE=100
# export BESU_TX_POOL_RETENTION_MINUTES=2
# export BESU_TX_POOL_ENTERPRISE_PENDING_TX_SORTER_ENABLED=true
export BESU_TX_POOL_TX_FAST_VERIFY_SIGNATURE_ENABLED=true
export BESU_PERF_ELIMINATE_REDUNDANT_BLOCK_VALIDATION_ENABLED=true

export BESU_RPC_HTTP_MAX_ACTIVE_CONNECTIONS=1000
export BESU_TX_POOL_MAX_SIZE=10000
export BESU_TX_POOL_LIMIT_BY_ACCOUNT_PERCENTAGE=1.0
#export BESU_RPC_HTTP_API=ETH,NET,WEB3,TXPOOL,DEBUG,ADMIN

export BESU_TX_POOL=legacy

#######################################

#Check Requirement
if ! [ -e $besuSourcePath ] ; then
	echo "[Error] '$besuSourcePath' directory does not exist."
	exit 1
fi

function chkExexResult {
    if [ $1 -ne 0 ] ; then
        echo 'exit by fail ('$2' -> exitCode:'$1')'
        exit 1
    fi
}

function checkRunning {

  echo '* check besu process...'
  ps -ef | grep "org.hyperledger.besu.Besu --config-file="$besuConfPath | awk '{print $2, $7, $8}' > status.txt

  number=`cat status.txt | wc -l`

  if [ "1" == "$number" ]; then
    if  [ "1" == "$1" ]; then
      echo "fail to start besu"
      exit 1
    fi
    #echo "besu is not start yet."
  else
    if  [ "2" == "$1" ]; then
      echo "besu is already running..."
      exit
    fi
    echo "besu is running..."
  fi
}

echo '\n* Exec besu --version'
$besuPath --version
chkExexResult $? $besuPath

pwd
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"
echo  workingDir: $workingDir

# besu가 이미 실행 중이면, 스크립트 종료
checkRunning 2
sleep 3

echo '* node1 (Exec) besu --config-file='$besuConfPath
$besuPath --config-file=$besuConfPath

# nohup.out 파일 생성하여, 콘솔출력 저장 및 백그라운드 작업 실행
#nohup $besuPath --config-file=$besuConfPath &
# nohup.out 파일 생성없음.(콘솔출력 저장도 없음) 백그라운드 작업 실행
#nohup $besuPath --config-file=$besuConfPath 1> /dev/null 2>&1 &
