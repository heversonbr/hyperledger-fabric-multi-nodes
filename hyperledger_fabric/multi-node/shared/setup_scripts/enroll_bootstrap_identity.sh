#!/bin/bash

# Enroll the bootstrap admin identity for the server
# The enroll command stores an enrollment certificate (ECert), 
# corresponding private key and CA certificate chain PEM files 
# in the subdirectories of the Fabric CA client’s msp directory.

CA_SERVER_HOST=192.168.1.10
ADMIN_USER=admin
ADMIN_PASS=pw

SUBDIR=caserver/admin

echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG" ]; then
    echo "Using client YAML: $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG"
else
    echo "Client YAML not found in $FABRIC_CA_CLIENT_HOME/"
    echo "mkdir -p $FABRIC_CA_CLIENT_HOME"
    mkdir -p $FABRIC_CA_CLIENT_HOME
    
    echo "Copying the $FABRIC_CONFIG_FILES/$FABRIC_CA_CLIENT_CONFIG to $FABRIC_CA_CLIENT_HOME"
    cp  $FABRIC_CONFIG_FILES/$FABRIC_CA_CLIENT_CONFIG $FABRIC_CA_CLIENT_HOME/
fi

echo "Enrolling ca-client with: $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG"

#  fabric-ca-client enroll -u http://admin:pw@localhost:7054
fabric-ca-client enroll -u http://$ADMIN_USER:$ADMIN_PASS@$CA_SERVER_HOST:7054
echo "-------------- showing identities ----------------------"
fabric-ca-client identity list
echo "--------------------------------------------------------"


# The enroll command stores an enrollment certificate (ECert), 
# corresponding private key and CA certificate chain PEM files 
# in the subdirectories of the Fabric CA client’s msp directory. 
# You will see messages indicating where the PEM files are stored.