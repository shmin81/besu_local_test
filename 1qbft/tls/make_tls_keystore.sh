#!/bin/sh

# penSSL은 명령 줄에서 TLS/SSL 프로토콜을 구현하는 오픈 소스 도구입니다.
# 개인 키와 인증서 생성
openssl req -new -x509 -days 365 -nodes -keyout myPrivatekey.key -out myCertificate.crt
# 위 명령은 1년 유효 기간의 개인 키와 인증서를 생성합니다

# TLS용 keystore.pfx 파일을 생성하는 방법에 대해 알려드리겠습니다.
# OpenSSL을 사용하여 PEM 및 CRT 파일에서 PFX 파일로 변환하는 방법을 설명드리겠습니다.

# method 1: PEM 파일을 PFX 파일로 변환:
#아래 명령어를 사용하여 개인 키와 인증서를 함께 포함하는 PFX 파일을 생성합니다:
openssl pkcs12 -export -out keystore.pfx -inkey myPrivatekey.key -in myCertificate.crt -certfile CA.pem
#private.key: 개인 키 파일의 경로
#certificate.crt: 인증서 파일의 경로
#CA.pem: CA(인증 기관) 인증서 파일의 경로 (Optional) - 없을 경우, self-signed certificate가 됨.
#적절한 파일 경로와 이름을 사용하여 명령어를 실행하면 keystore.pfx라는 새로운 PFX 파일이 생성됩니다.
