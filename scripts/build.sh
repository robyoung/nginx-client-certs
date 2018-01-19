#!/bin/bash
./scripts/build-ca.sh
echo ""
./scripts/build-server.sh backend secure client
echo ""
./scripts/build-server.sh proxy secure-open secure-secure secure-client
echo ""
./scripts/build-client.sh
