#!/bin/bash

# Register an identity with Fabric CA server
# 2. Register acme-admin
# ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
# fabric-ca-client register --id.type client --id.name acme-admin --id.secret pw --id.affiliation acme --id.attrs $ATTRIBUTES

usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./register_admin.sh <type> <name> <pass> <affiliation> <organization>"
    echo "   ex: ./register_admin.sh client acme-admin    pw  acme    acme "
    echo "   ex: ./register_admin.sh client budget-admin  pw  budget  budget "
    echo "   ex: ./register_admin.sh client orderer-admin pw  orderer orderer "
    echo "------------------------------------------------------------------------"
    exit
}

if [ $# -ne 5 ]; then
    usage
fi

TYPE=$1
NAME=$2
PASS=$3
AFFILIATION=$4
ORG=$5

#ATTRIBUTES="\"hf.Registrar.Roles=peer,user,client\",\"hf.AffiliationMgr=true","hf.Revoker=true\""
#ATTRIBUTES_ORDERER="\"hf.Registrar.Roles=orderer\""

ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
ATTRIBUTES_ORDERER='"hf.Registrar.Roles=orderer"'

# AFFILIATION will be used as org name to define the subdirectory (try to check later why the org name is not mentioned here)
SUBDIR=caserver/admin
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "my FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

ls -al  $FABRIC_CA_CLIENT_HOME



if [ "$NAME" == "orderer-admin" ]; then
    echo "registering an orderer , setting attributes"
    ATTRIBUTES=$ATTRIBUTES_ORDERER
fi

echo "Registering: $NAME"
fabric-ca-client register --id.type $TYPE --id.name $NAME --id.secret $PASS --id.affiliation $AFFILIATION --id.attrs $ATTRIBUTES

echo "NOTE:  inform the user <$NAME> and password <$PASS> to the admin of the organization <$ORG> (this information is also required to enroll organization's clients)"