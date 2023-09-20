#!/bin/bash
clear
workingDir=$(pwd)
echo $workingDir

# 자바 버전 셋팅
#export JAVA_HOME=$(/usr/libexec/java_home -v 17)

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

function chkExexResult {
    if [ $1 -ne 0 ] ; then
        echo 'exit by fail ('$2' -> exitCode:'$1')'
        exit 1
    fi
}

# besu 소스코드를 빌드할 필요가 있을 경우
cd $besuSourcePath
./gradlew installDist
chkExexResult $? './gradlew installDist'
cd $workingDir

echo '\n* Exec besu --version'
$besuPath --version
chkExexResult $? $besuPath
