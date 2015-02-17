#!/bin/bash -eux

PEM_FILE=${1}
CRT_FILE=/tmp/`basename ${PEM_FILE} | sed 's/pem/crt/'`
DIR=`dirname ${PEM_FILE}`
URL=`openssl x509 -in ${PEM_FILE} -text | grep OCSP | cut -d: -f2,3`
HEADER=`echo $URL | cut -d/ -f3`
ISSUER_CRT_URL=`openssl x509 -in ${PEM_FILE} -text | grep Issuers | cut -d: -f2,3`
wget ${ISSUER_CRT_URL} -q -O - | openssl x509 -inform DER -outform PEM > ${PEM_FILE}.issuer
openssl x509 -outform PEM -in ${PEM_FILE} > ${CRT_FILE}
openssl ocsp -noverify -issuer ${PEM_FILE}.issuer -cert ${CRT_FILE} -url ${URL} -no_nonce -header Host ${HEADER}  -respout ${PEM_FILE}.ocsp

