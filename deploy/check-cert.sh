#!/bin/sh
if [ $# -eq 2 ]; then
  CA=$2
else
  CA="startssl"
fi
echo "CA is $CA"

echo Some information about cert ../orchestration/TLS/cert/$1.cert:
openssl x509 -text -in ../orchestration/TLS/cert/$1.cert | head -50 | grep -v ^\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

#echo Some information about chain cert ../orchestration/TLS/chain/$2.pem:
#openssl x509 -text -in ../orchestration/TLS/chain/$2.pem

#echo Some information about key ../orchestration/TLS/key/$1.key:
#openssl rsa -text -in ../orchestration/TLS/key/$1.key

cat ../orchestration/TLS/cert/$1.cert ../orchestration/TLS/chain/$CA.pem ../orchestration/TLS/key/$1.key > ../orchestration/TLS/combined/$1.pem

echo Running a test server on port 4433 on this server now \(please use your browser to check\):
openssl s_server -cert ../orchestration/TLS/combined/$1.pem -www
