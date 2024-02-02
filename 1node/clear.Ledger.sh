#!/bin/bash
# node 2,3,4는 background에서 실행하고, node 1을 foreground에서 실행
# node 2,3,4는 다른 스크립트(stopAllNodes.sh)를 이용해 중지 가능

clear

workingDir=$(pwd)
echo $workingDir

echo 'remove old datas'
rm -rf ./node01/data/*
