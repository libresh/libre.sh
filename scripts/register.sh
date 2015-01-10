#!/usr/bin/env bash
# Register a user for IndiePaaS
#
# This file:
#  - Registers the domain name to NameCheap
#  - Generates the TLS certificate associated
#  - Configures the DNS
#  - Configures the mail forwarding
#
# Version 0.0.1 
#
# Authors:
#  - Pierre Ozoux (pierre-o.fr)
#
# Usage:
#  LOG_LEVEL=7 ./register.sh -n example.org -d
#
# Licensed under AGPLv3


### Configuration
#####################################################################

# Environment variables and their defaults
LOG_LEVEL="${LOG_LEVEL:-6}" # 7 = debug -> 0 = emergency

# Commandline options. This defines the usage page, and is used to parse cli
# opts & defaults from. The parsing is unforgiving so be precise in your syntax
read -r -d '' usage <<-'EOF'
  -n   [arg] Domain name to process. Required.
  -d         Enables debug mode
  -h         This page
EOF

### Functions
#####################################################################

function contains () {
  local n=$#
  local value=${!n}
  for ((i=1;i < $#;i++)) {
    if [ "${!i}" == "${value}" ]; then
      echo "y"
      return 0
    fi
  }
  echo "n"
  return 1
}

function TLD () {
  echo ${arg_n} | cut -d. -f2,3
}

function SLD () {
  echo ${arg_n} | cut -d. -f1
}

function call_API () {
  output=$(curl -s "https://api.$NAMECHEAP_URL/xml.response\?ApiUser=${NAMECHEAP_API_USER}&ApiKey=${NAMECHEAP_API_KEY}&UserName=${NAMECHEAP_API_USER}&ClientIp=${IP}$1")

  if [ -z $(echo ${output} | grep 'Status="OK"') ]; then
    error "API call failed. Please read the output"
    echo ${output}
    exit 1
  else
    info "API call is a success."
  fi

}

function create_domain_name () {

  not_supported_extensions=("us" "eu" "nu" "asia" "ca" "co.uk" "me.uk" "org.uk" "com.au" "net.au" "org.au" "es" "nom.es" "com.es" "org.es" "de" "fr" "")
  if [ $(contains "${not_supported_extensions[@]}" "$(TLD)") == "y" ]; then
    error "Extension .${extension} is not yet supported.."
    exit 1
  fi 

  info "Buying Domain name."
  arguments="&Command=namecheap.domains.create\
&DomainName=${arg_n}\
&Years=1\
&AuxBillingFirstName=${FirstName}\
&AuxBillingLastName=${LastName}\
&AuxBillingAddress1=${Address}\
&AuxBillingCity=${City}\
&AuxBillingPostalCode=${PostalCode}\
&AuxBillingCountry=${Country}\
&AuxBillingPhone=${Phone}\
&AuxBillingEmailAddress=${EmailAddress}\
&AuxBillingStateProvince=${City}\
&TechFirstName=${FirstName}\
&TechLastName=${LastName}\
&TechAddress1=${Address}\
&TechCity=${City}\
&TechPostalCode=${PostalCode}\
&TechCountry=${Country}\
&TechPhone=${Phone}\
&TechEmailAddress=${EmailAddress}\
&TechStateProvince=${City}\
&AdminFirstName=${FirstName}\
&AdminLastName=${LastName}\
&AdminAddress1=${Address}\
&AdminCity=${City}\
&AdminPostalCode=${PostalCode}\
&AdminCountry=${Country}\
&AdminPhone=${Phone}\
&AdminEmailAddress=${EmailAddress}\
&AdminStateProvince=${City}\
&RegistrantFirstName=${FirstName}\
&RegistrantLastName=${LastName}\
&RegistrantAddress1=${Address}\
&RegistrantCity=${City}\
&RegistrantPostalCode=${PostalCode}\
&RegistrantCountry=${Country}\
&RegistrantPhone=${Phone}\
&RegistrantEmailAddress=${EmailAddress}\
&RegistrantStateProvince=${City}"

  call_API ${arguments}

  info "Changing email forwarding."
  arguments="&Command=namecheap.domains.dns.setEmailForwarding\
&DomainName=${arg_n}\
&mailbox1=hostmaster\
&ForwardTo1=${EmailAddress}"

  call_API ${arguments}
}

function generate_certificate () {

  TLS_FOLDER=/data/import/${arg_n}/TLS

  info "Creating import folder."
  mkdir -p ${TLS_FOLDER}/CSR
  
  info "Generating the key."
  openssl genrsa -out ${TLS_FOLDER}//CSR/${arg_n}.key 4096

  info "Creating the request."
  openssl req -new \
    -key ${TLS_FOLDER}/CSR/${arg_n}.key \
    -out ${TLS_FOLDER}/CSR/${arg_n}.csr \
    -subj "/C=${CountryCode}/ST=${City}/L=${City}/O=${arg_n}/OU=/CN=${arg_n}/emailAddress=${EmailAddress}"

  info "Here is your CSR, paste it in your Certificate authority interface."
  echo ""
  cat ${TLS_FOLDER}/CSR/${arg_n}.csr

  echo ""
  info "You should have received a certificate"
  info "Please paste your certificate now"
  IFS= read -d '' -n 1 certificate
  while IFS= read -d '' -n 1 -t 2 c
  do
    certificate+=$c
  done

  if [ "${arg_d}" = "1" ]; then
    echo ${certificate}
  fi

  echo ${certificate} > ${TLS_FOLDER}/CSR/${arg_n}.cert

  info "Concat certificate, CA and key into pem file"
  cat ${TLS_FOLDER}/CSR/${arg_n}.cert /data/indiehosters/scripts/sub.class2.server.ca.pem ${TLS_FOLDER}/CSR/${arg_n}.key > ${TLS_FOLDER}/${arg_n}.pem
}

function configure_dns () {
  info "Configuring DNS."
  arguments="&Command=namecheap.domains.dns.setHosts\
&DomainName=${arg_n}\
&SLD=$(SLD)\
&TLD=$(TLD)\
&HostName1=@\
&RecordType1=A\
&Address1=${IP}\
&HostName2=www\
&RecordType2=CNAME\
&Address2=${arg_n}\
&HostName3=mail\
&RecordType3=A\
&Address3=${IP}\
&HostName4=@\
&RecordType4=MX\
&Address4=mail.${arg_n}\
&MXPref4=10"

  call_API ${arguments}

}

function _fmt ()      {
  local color_ok="\x1b[32m"
  local color_bad="\x1b[31m"

  local color="${color_bad}"
  if [ "${1}" = "debug" ] || [ "${1}" = "info" ] || [ "${1}" = "notice" ]; then
    color="${color_ok}"
  fi

  local color_reset="\x1b[0m"
  if [[ "${TERM}" != "xterm"* ]] || [ -t 1 ]; then
    # Don't use colors on pipes or non-recognized terminals
    color=""; color_reset=""
  fi
  echo -e "$(date -u +"%Y-%m-%d %H:%M:%S UTC") ${color}$(printf "[%9s]" ${1})${color_reset}";
}
function emergency () {                             echo "$(_fmt emergency) ${@}" 1>&2 || true; exit 1; }
function alert ()     { [ "${LOG_LEVEL}" -ge 1 ] && echo "$(_fmt alert) ${@}" 1>&2 || true; }
function critical ()  { [ "${LOG_LEVEL}" -ge 2 ] && echo "$(_fmt critical) ${@}" 1>&2 || true; }
function error ()     { [ "${LOG_LEVEL}" -ge 3 ] && echo "$(_fmt error) ${@}" 1>&2 || true; }
function warning ()   { [ "${LOG_LEVEL}" -ge 4 ] && echo "$(_fmt warning) ${@}" 1>&2 || true; }
function notice ()    { [ "${LOG_LEVEL}" -ge 5 ] && echo "$(_fmt notice) ${@}" 1>&2 || true; }
function info ()      { [ "${LOG_LEVEL}" -ge 6 ] && echo "$(_fmt info) ${@}" 1>&2 || true; }
function debug ()     { [ "${LOG_LEVEL}" -ge 7 ] && echo "$(_fmt debug) ${@}" 1>&2 || true; }

function help () {
  echo "" 1>&2
  echo " ${@}" 1>&2
  echo "" 1>&2
  echo "  ${usage}" 1>&2
  echo "" 1>&2
  exit 1
}

function cleanup_before_exit () {
  info "Cleaning up. Done"
}
trap cleanup_before_exit EXIT

### Parse commandline options
#####################################################################

# Translate usage string -> getopts arguments, and set $arg_<flag> defaults
while read line; do
  opt="$(echo "${line}" |awk '{print $1}' |sed -e 's#^-##')"
  if ! echo "${line}" |egrep '\[.*\]' >/dev/null 2>&1; then
    init="0" # it's a flag. init with 0
  else
    opt="${opt}:" # add : if opt has arg
    init=""  # it has an arg. init with ""
  fi
  opts="${opts}${opt}"

  varname="arg_${opt:0:1}"
  if ! echo "${line}" |egrep '\. Default=' >/dev/null 2>&1; then
    eval "${varname}=\"${init}\""
  else
    match="$(echo "${line}" |sed 's#^.*Default=\(\)#\1#g')"
    eval "${varname}=\"${match}\""
  fi
done <<< "${usage}"

# Reset in case getopts has been used previously in the shell.
OPTIND=1

# Overwrite $arg_<flag> defaults with the actual CLI options
while getopts "${opts}" opt; do
  line="$(echo "${usage}" |grep "\-${opt}")"


  [ "${opt}" = "?" ] && help "Invalid use of script: ${@} "
  varname="arg_${opt:0:1}"
  default="${!varname}"

  value="${OPTARG}"
  if [ -z "${OPTARG}" ] && [ "${default}" = "0" ]; then
    value="1"
  fi

  eval "${varname}=\"${value}\""
  debug "cli arg ${varname} = ($default) -> ${!varname}"
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift


### Switches (like -d for debugmdoe, -h for showing helppage)
#####################################################################

# debug mode
if [ "${arg_d}" = "1" ]; then
  set -o xtrace
  LOG_LEVEL="7"
fi

# help mode
if [ "${arg_h}" = "1" ]; then
  # Help exists with code 1
  help "Help using ${0}"
fi


### Validation (decide what's required for running your script and error out)
#####################################################################

[ -z "${arg_n}" ]     && help      "Setting a domain name with -n is required"
[ -z "${LOG_LEVEL}" ] && emergency "Cannot continue without LOG_LEVEL. "


### Runtime
#####################################################################

# Exit on error. Append ||true if you expect an error.
# set -e is safer than #!/bin/bash -e because that is neutralised if
# someone runs your script like `bash yourscript.sh`
set -o errexit
set -o nounset

# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`
set -o pipefail

if [[ "${OSTYPE}" == "darwin"* ]]; then
  info "You are on OSX"
fi

create_domain_name
generate_certificate
configure_dns
