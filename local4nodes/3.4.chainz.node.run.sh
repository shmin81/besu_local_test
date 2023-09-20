#!/bin/bash
clear

# echo 'remove old datas'
# rm -rf ./node04/data/*

#export JAVA_HOME=$(/usr/libexec/java_home -v 11)

besuPath=../../../gitlab/besu-client/build/install/besu/bin/besu

echo '\n* Exec besu --version'
$besuPath --version

echo "$(date +%Y)년 $(date +%m)월 $(date +%d)일  $(date +%H)시 $(date +%M)분 $(date +%S)초"

echo '\n* node4 Exec besu --config-file xxx'
$besuPath --config-file="./node04/conf4.toml"
