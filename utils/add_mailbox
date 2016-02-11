#!/bin/bash
set -e
set -u
set -x

source /etc/environment

email=$1
email_password=$2

local_part=`echo $email | cut -d@ -f1`
email_domain=`echo $email | cut -d@ -f2`

curl --data "username=${mail_username}&password=${mail_password}&login=Log+In&rememberme=0" -c /tmp/cookie.txt https://${mail_hostname}/auth/login
domain_id=`curl -b /tmp/cookie.txt https://${mail_hostname}/domain | grep $email_domain | grep purge-domain | grep -o 'purge-domain-[0-9]*' | grep -o '[0-9]*'`
curl --data "local_part=${local_part}&domain=${domain_id}&password=${email_password}" -b /tmp/cookie.txt https://${mail_hostname}/mailbox/add

rm /tmp/cookie.txt
