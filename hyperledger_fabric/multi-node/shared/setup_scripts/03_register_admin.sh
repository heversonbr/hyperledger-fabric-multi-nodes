#!/bin/bash

# Register an identity with Fabric CA server. Example:
# 2. Register acme-admin
# ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
# fabric-ca-client register --id.type client --id.name acme-admin --id.secret pw --id.affiliation acme --id.attrs $ATTRIBUTES
# The identity performing the register request must be currently enrolled

usage(){
    echo "-----------------------------------------------------------------------------"
    echo "USAGE: ./register_admin.sh <type> <name> <pass> <organization> <affiliation> "
    echo "   ex: ./03_register_admin.sh client  bcom-admin     pw  bcom    bcom   "
    echo "   ex: ./03_register_admin.sh client  orange-admin   pw  orange  orange "
    echo "   ex: ./03_register_admin.sh client  orderer-admin  pw  orderer orderer"
    echo "------------------------------------------------------------------------------"
    exit
}

if [ $# -ne 5 ]; then
    usage
fi

TYPE=$1
NAME=$2
PASS=$3
ORG=$4
AFFILIATION=$5

ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
ATTRIBUTES_ORDERER='"hf.Registrar.Roles=orderer"'

# Set ca-client variable
SUBDIR=caserver/admin
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$BASE_FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"


if [ "$NAME" == "orderer-admin" ]; then
    echo "registering an orderer , setting attributes"
    ATTRIBUTES=$ATTRIBUTES_ORDERER
fi

echo "Registering: $NAME"
fabric-ca-client register --id.type $TYPE --id.name $NAME --id.secret $PASS --id.affiliation $AFFILIATION --id.attrs $ATTRIBUTES

echo "NOTE:  inform the user <$NAME> and password <$PASS> to the admin of the organization <$ORG> (this information is also required to enroll organization's clients)"