#!/bin/bash

function usage {
    echo    "-----------------------------------------------"
    echo    "USAGE: .  ./list_ca-client_identity_list.sh <org> {default= org-admin pw}"
    echo    "   ex: .  ./set-ca-client.sh acme {default= acme-admin acme-admin-pw}"
    echo    "-----------------------------------------------"
    exit
}

if [ $# -ne 1 ]; then
    usage
fi

ORG=$1
ADMIN_USER_NAME=admin
ADMIN_USER_PW=pw

CA_SERVER_HOST_IP=192.168.1.10

echo "------------Fabric ENV -----------------"
./list_env_vars.sh
echo "----------------------------------------"

SUBDIR=$ORG/$ADMIN_USER_NAME
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
echo "----------------------------------------"



fabric-ca-client enroll -u http://$ADMIN_USER_NAME:$ADMIN_USER_PW@$CA_SERVER_HOST_IP:7054
fabric-ca-client identity list
echo "----------------------------------------"


