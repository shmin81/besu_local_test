#!/bin/bash
clear
cd ..
echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"

# echo 'remove old datas'
# rm -rf ./node01/data/*

sh common.env.sh

besuPath=$(cat ./besuPath.tmp)
echo 'besu:' $besuPath

# echo '\n* Exec besu --version'
# $besuPath --version

echo '\n* node4 Exec besu --config-file xxx'
$besuPath --config-file="./node04/conf4.toml"
