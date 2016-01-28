#!/bin/bash -eux

source /etc/environment

function provision_dkim () {
  docker exec mailindiehost_postfix_1 /add_domain.sh ${arg_u}
}


function configure_dns () {
  domain_key=`cat /data/domains/mail.indie.host/opendkim/keys/${arg_u}/mail.txt | cut -d\" -f2 | sed 'N;s/\n//g' | sed 's/ //g'`
  info "Configuring DNS."
  arguments="&Command=namecheap.domains.dns.setHosts\
&DomainName=${arg_u}\
&SLD=$(SLD)\
&TLD=$(TLD)\
&HostName1=@\
&RecordType1=A\
&Address1=${IP}\
&HostName2=www\
&RecordType2=CNAME\
&Address2=${arg_u}\
&HostName3=@\
&RecordType3=MX\
&Address3=${mail_hostname}\
&MXPref3=10\
&HostName4=@\
&RecordType4=TXT\
&Address4=v=spf1%20include:${mail_hostname}\
&Hostname5=_dmarc\
&RecordType5=TXT\
&Address5=v=DMARC1;%20p=none;%20rua=mailto:support@indie.host\
&HostName6=mail._domainkey\
&RecordType6=TXT\
&Address6=${domain_key}\
&HostName7=autoconfig\
&RecordType7=CNAME\
&Address7=autoconfig.`echo $mail_hostname | cut -d. -f2,3`\
&EmailType=mx"
  call_API ${arguments}

}

