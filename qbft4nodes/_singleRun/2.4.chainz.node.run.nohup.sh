#!/bin/bash
clear
cd ..
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"

# echo 'remove old datas'
# rm -rf ./node04/data/*

export BESU_IDENTITY="val04"

# besuSourcePath=$workingDir/../../besu-binary/23.1.3.2
# #besuPath=$besuSourcePath/build/install/besu/bin/besu
# besuPath=$besuSourcePath/bin/besu

sh common.env.sh
besuPath=$(cat ./besuPath.tmp)

echo 'besu:' $besuPath

# echo '\n* Exec besu --version'
# $besuPath --version

echo '\n* node4 Exec besu --config-file xxx'
nohup $besuPath --config-file="./node04/conf4.toml" --identity=$BESU_IDENTITY > node04.log 2>&1 &
