#!/bin/bash
clear
cd ..
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"

# echo 'remove old datas'
# rm -rf ./node02/data/*

export BESU_IDENTITY="val02"

# besuSourcePath=$workingDir/../../besu-binary/23.1.3.2
# #besuPath=$besuSourcePath/build/install/besu/bin/besu
# besuPath=$besuSourcePath/bin/besu

sh common.env.sh
besuPath=$(cat ./besuPath.tmp)

echo 'besu:' $besuPath

# echo '\n* Exec besu --version'
# $besuPath --version

echo '\n* node2 Exec besu --config-file xxx'
$besuPath --config-file="./node02/conf2.toml" --identity=$BESU_IDENTITY
