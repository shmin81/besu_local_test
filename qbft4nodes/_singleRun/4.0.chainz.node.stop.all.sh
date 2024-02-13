#!/bin/bash

echo 'kill... besu process'

ps -ef | grep "org.hyperledger.besu.Besu --config-file=" | awk '{print $2}' | xargs kill

sleep 2
echo '====  status  ===='
ps -ef | grep "org.hyperledger.besu.Besu"