#!/bin/bash

function usage {
    echo    "-----------------------------------------------"
    echo    "USAGE: .  ./list_ca-client_identity_list.sh <org> <admin-user> <admin-user-pass> "
    echo    "   ex: .  ./set-ca-client.sh acme acme-admin acme-admin-pw "
    echo    "-----------------------------------------------"
    exit
}

if [ $# -ne 3 ]; then
    usage
fi

ORG=$1
ADMIN_USER_NAME=$2
ADMIN_USER_PW=$3

CA_SERVER_HOST_IP=192.168.1.10

echo "-----------------------------"
env | grep FABRIC
echo "-----------------------------"
# . ./set-ca-client.sh $ORG $USER
SUBDIR=$ORG/$USER
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
echo "-----------------------------"



fabric-ca-client enroll -u http://$ADMIN_USER_NAME:$ADMIN_USER_PW@$CA_SERVER_HOST_IP:7054
fabric-ca-client identity list
echo "-----------------------------"


