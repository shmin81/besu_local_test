#!bin/bash
######################
SHELL=bash
MAX_BLOCKS=600 
######################

workingDir=$(pwd)
echo $workingDir

$SHELL clear.Ledger.sh

sleep 1

nohup $SHELL run.node.log.sh &

sleep 10

cd ../test/scripts
node auto.check.blockNumber.js dev-local $MAX_BLOCKS

cd $workingDir

echo 'running... $(date)'
du -h --max-depth=1

$SHELL ../stopAllNodes.sh

sleep 2
echo 'stopped... $(date)'
du -h --max-depth=1

