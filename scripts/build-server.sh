#!/bin/bash

NAME=$1
shift

if [ -f ssl/$NAME-server.key ]; then
  echo "---- skipping generate $NAME"
  exit 0
fi

echo "==== generate $NAME"
openssl genrsa -out ssl/$NAME-server.key 2048
openssl req -new \
  -subj "/C=GB/CN=$NAME.test" \
  -key ssl/$NAME-server.key \
  -out ssl/$NAME-server.csr

cat > ssl/$NAME-server.ext <<END
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature,keyEncipherment
subjectAltName = @alt_names

[alt_names]
END
i=1
for subdomain in $@; do
  echo "DNS.$i = $subdomain.$NAME.test" >> ssl/$NAME-server.ext
  i=$(($i + 1))
done

openssl x509 \
  -req -in ssl/$NAME-server.csr \
  -passin pass:password \
  -CA ssl/test-ca.pem -CAkey ssl/test-ca.key -CAcreateserial \
  -out ssl/$NAME-server.crt \
  -days 1825 -sha256 \
  -extfile ssl/$NAME-server.ext
