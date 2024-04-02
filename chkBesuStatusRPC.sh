#!/bin/bash
# URL List 및 Service Name을 적는다.
urls=(
  "http://localhost:8545/liveness"
)
services=(
  "chainz besu"
)
# 루프를 돌려 테스트한다. 
for i in "${!urls[@]}"
do
  url="${urls[$i]}"
  service="${services[$i]}"
  response_code=$(curl -sL -o /dev/null -w "%{http_code}" $url)
  if [ "$response_code" -eq 200 ]; then
    echo "$url $service: OK"
  else
    echo "$url $service: ERROR ($response_code)"
  fi
done