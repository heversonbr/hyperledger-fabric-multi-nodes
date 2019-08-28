#!/bin/bash
# 
# the example below show what we do to register a new user jdoe
# . setclient.sh acme acme-admin   (.setclient.sh acme admin ???)
#
#fabric-ca-client enroll -u http://acme-admin:pw@192.168.1.10:7054
#fabric-ca-client register --id.type user --id.name jdoe --id.secret pw --id.affiliation acme.logistics
#fabric-ca-client identity list

# Register a new user for a given organizationn identity with Fabric CA server
#TODO: remove hard-coded variables (see below). still need to improve this script

usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./register_user.sh <new_user_name> <new_user_pass> <organization> <affiliation> "
    echo "   ex: ./register_user.sh jdoe pw acme acme.logistics"
    echo "------------------------------------------------------------------------"
    exit
}

if [ $# -ne 4 ]; then
    usage
fi

NEW_USER_NAME=$1
NEW_USER_PW=$2
ORG_NAME=$3
NEW_USER_AFFILIATION=$4  #acme.logistics

ORG_ADMIN_USER=$ORG_NAME-admin   #(.setclient.sh acme admin ???)
ORG_ADMIN_USER_PW=pw
CA_SERVER_HOST=192.168.1.10
TYPE=user

. set-ca-client.sh $ORG_NAME $ORG_ADMIN_USER

fabric-ca-client enroll -u http://$ORG_ADMIN_USER:$ORG_ADMIN_USER_PW@$CA_SERVER_HOST:7054
fabric-ca-client register --id.type $TYPE --id.name $NEW_USER_NAME --id.secret $NEW_USER_PW --id.affiliation $NEW_USER_AFFILIATION
echo "--------------------------------------------------"
fabric-ca-client identity list
echo "--------------------------------------------------"


