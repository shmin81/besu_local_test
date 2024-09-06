#!/bin/bash
clear
workingDir=$(pwd)
echo $workingDir
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"

shell=bash
# echo 'remove old datas'
#rm -rf ./node01/data/*

# 자바 버전 셋팅
#export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export BESU_OPTS=-Xmx1g

# 실행할 besu 소스코드 위치
besuSourcePath=$workingDir/../../../gitlab/besu-client
#besuSourcePath=$workingDir/../../../github-utils/besu-client-tmp

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
$besuPath --config-file="./node01/conf1.toml" --identity=besu1
