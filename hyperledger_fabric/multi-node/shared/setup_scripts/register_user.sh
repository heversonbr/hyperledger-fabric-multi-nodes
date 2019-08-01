#!/bin/bash
# 
# the example below show what we do to register a new user jdoe
# . setclient.sh acme acme-admin   (.setclient.sh acme admin ???)
#
#fabric-ca-client enroll -u http://acme-admin:pw@192.168.1.10:7054
#fabric-ca-client register --id.type user --id.name jdoe --id.secret pw --id.affiliation acme.logistics
#fabric-ca-client identity list

ORG_NAME=acme
ORG_ADMIN_USER=acme-admin # (.setclient.sh acme admin ???)
ORG_ADMIN_USER_PW=pw
CA_SERVER_HOST=192.168.1.10
NEW_USER_NAME=jdoe
NEW_USER_PW=pw
NEW_USER_AFFILIATION=acme.logistics

. set-ca-client.sh $ORG_NAME $ORG_ADMIN_USER

fabric-ca-client enroll -u http://$ORG_ADMIN_USER:$ORG_ADMIN_USER_PW@$CA_SERVER_HOST:7054
fabric-ca-client register --id.type user --id.name $NEW_USER_NAME --id.secret $NEW_USER_PW --id.affiliation $NEW_USER_AFFILIATION
echo "--------------------------------------------------"
fabric-ca-client identity list
echo "--------------------------------------------------"


