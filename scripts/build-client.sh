#!/bin/bash

if [ -f ssl/client.key ]; then
  echo '---- skipping generate client'
  exit 0
fi

echo "==== generate client"
openssl genrsa -out ssl/client.key 2048
openssl req -new \
  -subj "/C=GB" \
  -key ssl/client.key \
  -out ssl/client.csr
openssl x509 \
  -req -in ssl/client.csr \
  -passin pass:password \
  -CA ssl/test-ca.pem -CAkey ssl/test-ca.key -CAcreateserial \
  -out ssl/client.crt \
  -days 1825 -sha256

## convert client key to PKCS (for browsers)
openssl pkcs12 -export -clcerts \
  -passin pass:password \
  -passout pass:password \
  -in ssl/client.crt -inkey ssl/client.key -out ssl/client.p12

## convert to combined PEM (for curl)
openssl pkcs12 \
  -in ssl/client.p12 \
  -out ssl/client.pem \
  -passin pass:password \
  -passout pass:password \
  -clcerts

## passwordless combined PEM (for socat)
cat ssl/client.key ssl/client.crt ssl/test-ca.pem > ssl/client-nopass.pem
