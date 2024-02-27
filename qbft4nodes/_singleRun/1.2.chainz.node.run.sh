#!/bin/bash
clear
cd ..
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"

# echo 'remove old datas'
# rm -rf ./node02/data/*

export BESU_IDENTITY="val02"
export BESU_BOOTNODES=enode://d3045c8ef00ca882f4acfd2d4f76479d18245c2d6a6d7ad5a3047591919d94c114470863a9aa9e3fb6a93eca7569cfe143dcf321bfdbba419323ec305dcf6907@127.0.0.1:30303

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
