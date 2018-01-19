#!/bin/bash

if [ -f ssl/test-ca.key ]; then
  echo "---- skipping generate CA"
  exit 0
fi

echo "==== generate CA"
openssl genrsa -des3 -passout pass:password -out ssl/test-ca.key 2048
openssl req -x509 -new -nodes \
  -passin pass:password \
  -key ssl/test-ca.key \
  -sha256 -days 1825 \
  -subj "/C=GB/CN=test" \
  -out ssl/test-ca.pem
