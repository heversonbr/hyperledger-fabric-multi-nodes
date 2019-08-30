#!/bin/bash

# Enroll identity with Fabric CA server
# Example for acme-admin
#     echo "Enrolling: acme-admin"
#     ORG_NAME="acme"
#     source setclient.sh   $ORG_NAME   admin
#     checkCopyYAML
#     fabric-ca-client enroll -u http://acme-admin:pw@localhost:7054
#     setupMSP

# The enroll command stores:
# - an enrollment certificate (ECert), 
# - corresponding private key, and 
# - CA certificate chain PEM files 
# in the subdirectories of the Fabric CA client’s msp directory. 

usage(){
    echo "-------------------------------------------------------------"
    echo "USAGE: ./enroll_admin.sh <org_name> "
    echo "   EX: ./enroll_admin.sh acme"
    echo "   in this case, the default user to be enrolled is 'admin'"
    echo "-------------------------------------------------------------"
    exit
}

if [ $# -ne 2 ]; then
    usage
fi

ORG_NAME=$1

ADMIN_USER=$ORG_NAME-admin
ADMIN_USER_PW=pw
CA_SERVER_HOST=192.168.1.10

## set client home 
SUBDIR=$ORG_NAME/admin
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
 
# If client YAML not found then copy the client YAML before enrolling
if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG" ]; then 
    echo "Using the existing Client $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG for $ORG_NAME admin"
else
    echo "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG not found in $FABRIC_CA_CLIENT_HOME/"
    mkdir -p $FABRIC_CA_CLIENT_HOME

    echo "Copy the Client Yaml from $FABRIC_CONFIG_FILES/fabric-ca-client-config-$ORG_NAME.yaml "
    cp  $FABRIC_CONFIG_FILES/fabric-ca-client-config-$ORG_NAME.yaml $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG
    echo "checking with: ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG"
    ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG
fi

# enroll
echo "Enrolling admin identity: $ORG_NAME-$SERVER_ADMIN_USER"
# Exemple for acme:  fabric-ca-client enroll -u http://acme-admin:pw@localhost:7054
echo "fabric-ca-client enroll -u http://$ADMIN_USER:$ADMIN_USER_PW@$CA_SERVER_HOST:7054"
 fabric-ca-client enroll -u http://$ADMIN_USER:$ADMIN_USER_PW@$CA_SERVER_HOST:7054