#!/bin/bash

# Creates/Enrolls the Orderer's identity + Sets up MSP for orderer
# Script may executed multiple times 
# Similar to the register/enroll made for the orderer admin, but in this case the orderer admin is registering 
# and enrolling an identity of type orderer which is not the admin itself but it is the orderer node.

# Identity of the orderer will be created by the admin from the orderer organization
# NOTE: The identity performing the register request must be currently enrolled


usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./09_register_orderer.sh <ORDERER_NAME>  [PEER_PW , default=pw] [ORG_NAME , default=orderer]"
    echo "   ex: ./09_register_orderer.sh orderer-node [pw] [orderer]"
    echo "------------------------------------------------------------------------"
    exit
}


if [ -z $1 ];
then
    echo "Provide Orderer-node Name!!!"
    usage
else
    ORDERER_NAME=$1
    echo "Switching PEER_NAME for Org = $ORG_NAME"
fi

if [ -z $2 ]
then
    PEER_PW=pw
    echo "PEER_PW=$PEER_PW"
else
    PEER_PW=$2
    
fi


if [ -z $3 ]
then
    ORG_NAME="orderer"
    echo "ORG_NAME=$ORG_NAME"
else
    ORG_NAME=$2
    
fi




# sets the FABRIC_CA_CLIENT_HOME to the orderer admin
IDENTITY="admin"
ORG_NAME="orderer"

TYPE=orderer
CA_SERVER_HOST=192.168.1.10


ADMIN_CLIENT_HOME=$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/$IDENTITY

echo "my FABRIC_CA_CLIENT_HOME: $FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME="$ADMIN_CLIENT_HOME"
echo "now FABRIC_CA_CLIENT_HOME: $FABRIC_CA_CLIENT_HOME"


# ----------------------------------------------------------
# Step-1  Orderer Admin Registers the orderer identity
# NOTE: The identity performing the register request must be currently enrolle
echo "##################################################"
echo "# Registering orderer identity with orderer-admin "
echo "##################################################"
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
echo "Registering :=> fabric-ca-client register --id.type orderer --id.name orderer --id.secret pw --id.affiliation orderer "
fabric-ca-client register --id.type $TYPE --id.name $ORDERER_NAME --id.secret $PEER_PW --id.affiliation $ORG_NAME
echo "======Completed: Step 1 : Registered orderer (can be done only once)===="
