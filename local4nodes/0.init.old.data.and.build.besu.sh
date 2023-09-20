#!/bin/bash
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
#export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# 실행할 besu 소스코드 위치 
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
