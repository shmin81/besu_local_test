#!/bin/bash
clear

cd ..
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"

# echo 'remove old datas'
# rm -rf ./node01/data/*

export BESU_IDENTITY="val01"

# besuSourcePath=$workingDir/../../besu-binary/23.1.3.2
# #besuPath=$besuSourcePath/build/install/besu/bin/besu
# besuPath=$besuSourcePath/bin/besu

sh common.env.sh
besuPath=$(cat ./besuPath.tmp)

echo 'besu:' $besuPath

# echo '\n* Exec besu --version'
# $besuPath --version

echo '\n* node1 Exec besu --config-file xxx'
$besuPath --config-file="./node01/conf1.toml" --identity=$BESU_IDENTITY
