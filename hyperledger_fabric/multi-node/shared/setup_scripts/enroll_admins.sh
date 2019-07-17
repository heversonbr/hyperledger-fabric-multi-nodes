#!/bin/bash

# Enroll identity with Fabric CA server
# Example for acme-admin
#     echo "Enrolling: acme-admin"
#     ORG_NAME="acme"
#     source setclient.sh   $ORG_NAME   admin
#     checkCopyYAML
#     fabric-ca-client enroll -u http://acme-admin:pw@localhost:7054
#     setupMSP


usage(){
    echo "-------------------------------------------------------------"
    echo "USAGE: ./enroll_admin.sh <org_name> "
    echo "   EX: ./enroll_admin.sh acme"
    echo "-------------------------------------------------------------"
    exit
}

if [ $# -ne 1 ]; then
    usage
fi

ORG_NAME=$1

SERVER_ADMIN_USER=admin
SERVER_ADMIN_PASS=pw
CA_SERVER_HOST=192.168.1.10


SUBDIR=$ORG_NAME/admin
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "my FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

# If client YAML not found then copy the client YAML before enrolling
if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG" ]; then 
    echo "Using the existing Client $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG for $ORG_NAME admin"
else
    echo "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG not found in $FABRIC_CA_CLIENT_HOME/"
    mkdir -p $FABRIC_CA_CLIENT_HOME

    echo "Copy the Client Yaml from $FABRIC_CONFIG_FILES/fabric-ca-client-config-$ORG_NAME.yaml "
    cp  $FABRIC_CONFIG_FILES/fabric-ca-client-config-$ORG_NAME.yaml $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG
    ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG
fi


echo "Enrolling: $ORG_NAME-admin"

# Exemple for acme:  fabric-ca-client enroll -u http://acme-admin:pw@localhost:7054
echo "fabric-ca-client enroll -u http://$ORG_NAME-$SERVER_ADMIN_USER:$SERVER_ADMIN_PASS@$CA_SERVER_HOST:7054"
fabric-ca-client enroll -u http://$ORG_NAME-$SERVER_ADMIN_USER:$SERVER_ADMIN_PASS@$CA_SERVER_HOST:7054

### setupMSP ### 
ls -al $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "Creating $FABRIC_CA_CLIENT_HOME/msp/admincerts"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
ls -al $FABRIC_CA_CLIENT_HOME/msp/admincerts

echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"


echo "cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts"
cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
ls -al $FABRIC_CA_CLIENT_HOME/msp/admincerts