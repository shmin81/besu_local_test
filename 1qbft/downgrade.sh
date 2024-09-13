#!bin/sh
workingDir=$(pwd)
echo $workingDir

besuInstalledPath=$workingDir/../../../besu-binary/24.7.1
besuPath=$besuInstalledPath/bin/besu

echo ''
echo 'revert-variables (v23.4.4에 도입)'
$besuPath --config-file ./node01/conf1.toml storage revert-variables

echo ''
echo 'revert-metadata v2-to-v1 (v24.5.1에 도입)'
# usage: besu --data-path=/path/to/besu/datadir storage revert-metadata v2-to-v1
$besuPath --config-file ./node01/conf1.toml storage revert-metadata v2-to-v1
