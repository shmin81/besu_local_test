#!bin/bash

workingDir=$(pwd)
echo $workingDir

## 실행할 위치 (besu version)
besuSourcePath=$workingDir/../../besu-client
besuSourcePath=$workingDir/../../besu-binary/24.1.1

## 실행할 besu 바이너리 위치 
besuPath=$besuSourcePath/build/install/besu/bin/besu
besuPath=$besuSourcePath/bin/besu
#besuPath=besu

echo '\n* Exec besu --version'
$besuPath --version
exitCode=$?
if [ $exitCode -ne 0 ] ; then
    echo 'exit by fail ('$besuPath' --version -> exitCode:'$exitCode')'
    rm -f ./besuPath.tmp
    exit 1
fi

echo $besuPath > ./besuPath.tmp
