if [ -f /data/per-user/$1/tls.cert ]; then
if [ -f /data/per-user/$1/tls.key ]; then
if [ -f /data/per-user/$1/chain.pem ]; then
  echo head -5 /data/per-user/$1/tls.cert:
  head -5 /data/per-user/$1/tls.cert
  echo head -5 /data/per-user/$1/chain.pem:
  head -5 /data/per-user/$1/chain.pem
  echo head -5 /data/per-user/$1/tls.key:
  head -5 /data/per-user/$1/tls.key

  echo Some information about: /data/per-user/$1/tls.cert:
  openssl x509 -text -in /data/per-user/$1/tls.cert

  echo Some information about: /data/per-user/$1/chain.pem:
  openssl x509 -text -in /data/per-user/$1/chain.pem

  echo Some information about: /data/per-user/$1/tls.key:
  openssl rsa -text -in /data/per-user/$1/tls.key

  if [ -f /data/per-user/$1/combined.pem ]; then
    echo combined.pem exists! Please make sure it\'s tls.cert + chain.pem + tls.key \(in that order\)
  else
    echo Generating /data/per-user/$1/combined.pem:
    cat /data/per-user/$1/tls.cert /data/per-user/$1/chain.pem /data/per-user/$1/tls.key > /data/per-user/$1/combined.pem
  fi

  echo Running a test server on port 4433 on this server now \(please use your browser to check\):
  openssl s_server -cert /data/per-user/$1/combined.pem -www
else
  echo Files /data/per-user/$1/{tls.cert,tls.key,chain.pem} not found
fi
else
  echo Files /data/per-user/$1/{tls.cert,tls.key,chain.pem} not found
fi
else
  echo Files /data/per-user/$1/{tls.cert,tls.key,chain.pem} not found
fi
