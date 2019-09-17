#!/bin/bash
#TODO: to be finished
ORG_HOSTNAME=

ORG_NAME=

CERTS_DIR=

IDENTITY=
FABRIC_CA_CLIENT_HOME=

echo "Getting admin certs with SCP"
echo "scp -r $ORG_HOSTNAME:$CERTS_DIR/* $DESTINATION"
scp -r $ORG_HOSTNAME:$CERTS_DIR/* $FABRIC_CA_CLIENT_HOME/$ORG_NAME/$IDENTITY/msp/admincerts