#!/bin/bash
# 
# the example below show what we do to register a new user jdoe
# . setclient.sh acme acme-admin   (.setclient.sh acme admin ???)
#
#fabric-ca-client enroll -u http://acme-admin:pw@192.168.1.10:7054
#fabric-ca-client register --id.type user --id.name jdoe --id.secret pw --id.affiliation acme.logistics
#fabric-ca-client identity list
# NOTE: The identity performing the register request must be currently enrolle
# Register a new user for a given organizationn identity with Fabric CA server

#TODO: remove hard-coded variables (see below). still need to improve this script

usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./register_user.sh <user> <user_pw> <organization> <affiliation> <org-admin> <org-admin-pw>"
    echo "   ex: ./register_user.sh jdoe pw acme acme.logistics acme-admin pw"
    echo "------------------------------------------------------------------------"
    exit
}
# <user> <user_pw> <organization> <affiliation> <org-admin> <org-admin-pw>

if [ $# -ne 6 ]; then
    usage
fi

NEW_USER=$1
NEW_USER_PW=$2
ORG=$3
NEW_USER_AFFILIATION=$4  #acme.logistics
ADMIN_USER_NAME=$5
ADMIN_USER_PW=$6

TYPE=user
CA_SERVER_HOST_IP=192.168.1.10

#TODO: to check this set home!
#. set-ca-client.sh $ORG_NAME $ORG_ADMIN_USER
SUBDIR=$ORG/$NEW_USER
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
# NOTE: The identity performing the register request must be currently enrolle
fabric-ca-client enroll -u http://$ADMIN_USER_NAME:$ADMIN_USER_PW@$CA_SERVER_HOST_IP:7054
fabric-ca-client register --id.type $TYPE --id.name $NEW_USER --id.secret $NEW_USER_PW --id.affiliation $NEW_USER_AFFILIATION
echo "------------------Listing Identities --------------------------"
fabric-ca-client identity list
echo "---------------------------------------------------------------"


