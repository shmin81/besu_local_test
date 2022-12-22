# besu_local_test

# besu build and run process
1. install jdk11 https://bcp0109.tistory.com/302
2. git clone https://github.com/hyperledger/besu.git -> {{besu source}} : 다운받은 소스코드 경로 
3. {{besu_local_test}}/local4nodes 설정 파일 확인 (genesis_IBFT2.json)
4. {{besu_local_test}}/local4nodes/node{x} 폴더 안의 conf{x}.toml 파일의 경로 수정 -> {{besu_local_test}}의 경로로 수정
5. vi runAllNodes.new.sh (or runAllNodes.sh) 파일 확인 및 수정 -> {{besu source}}의 경로로 수정 
6. sh runAllNodes.new.sh (or runAllNodes.sh)

# besu run only process
1. install jdk11
2. 로컬에 besu 설치(https://besu.hyperledger.org/en/21.10.9/HowTo/Get-Started/Installation-Options/Install-Binaries/)
3. {{besu_local_test}}/local4nodes 설정 파일 확인 (genesis_IBFT2.json)
4. {{besu_local_test}}/local4nodes/node{x} 폴더 안의 conf{x}.toml 파일의 경로 수정 -> {{besu_local_test}}의 경로로 수정
5. runAllNodes.new.sh (or runAllNodes.sh) 파일 확인 및 수정 -> 24~28라인은 주석처리하고, 30라인을 besuPath=besu로 수정
6. sh runAllNodes.new.sh (or runAllNodes.sh)

# test
- web3.js https://web3js.readthedocs.io/en/v1.7.5/
