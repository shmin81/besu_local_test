#!/bin/bash
clear

workingDir=$(pwd)
echo 'Working Dir: '$workingDir

##########################################
nodeAddrPath=./nodeAddress_Input.json
#consensus=IBFT
consensus=QBFT
##########################################
echo 'Consensus Algorithm : '$consensus

# 실행할 besu 소스코드 위치 
#besuSourcePath=/Users/????/Downloads/gitlab/besu-client
besuSourcePath=$workingDir/../../gitlab/besu-client
#besuSourcePath=~/besu-binary/24.1.1
# 실행할 besu 바이너리 위치 
besuPath=$besuSourcePath/build/install/besu/bin/besu
#besuPath=$besuSourcePath/bin/besu

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

##
chkPathResult $nodeAddrPath

## 
echo '\n* Exec java --version'
java --version
chkExexResult $? 'java'

echo '\n* Exec besu --version'
$besuPath --version
chkExexResult $? $besuPath

sleep 2
echo ''
# besu rlp encode [--from=<FILE>] [--to=<FILE>] [--type=<type>]
echo '* Exec: besu rlp encode --from='$nodeAddrPath --to='extra_data_for_'$consensus'_genesis.txt' --type=$consensus'_EXTRA_DATA'
$besuPath rlp encode --from=$nodeAddrPath --to='extra_data_for_'$consensus'_genesis.txt' --type=$consensus'_EXTRA_DATA'

echo 'done.'