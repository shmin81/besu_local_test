#!/bin/bash

echo 'kill... besu process'
ps -ef | grep "org.hyperledger.besu.Besu --config-file=./node01/conf1.toml" | awk '{print $2}' | xargs kill
# ps -ef | grep "org.hyperledger.besu.Besu --config-file=./node02/conf2.toml" | awk '{print $2}' | xargs kill
# ps -ef | grep "org.hyperledger.besu.Besu --config-file=./node03/conf3.toml" | awk '{print $2}' | xargs kill
# ps -ef | grep "org.hyperledger.besu.Besu --config-file=./node04/conf4.toml" | awk '{print $2}' | xargs kill

sleep 2
echo '====  status  ===='
ps -ef | grep "org.hyperledger.besu.Besu"