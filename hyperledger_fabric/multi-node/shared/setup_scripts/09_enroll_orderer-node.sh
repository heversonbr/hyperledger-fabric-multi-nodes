#!/bin/bash
# Creates/Enrolls the Orderer's identity + Sets up MSP for orderer
# Script may executed multiple times 
# Similar to the register/enroll made for the orderer admin, but in this case the orderer admin is registering 
# and enrolling an identity of type orderer which is not the admin itself but it is the orderer node.
# Identity of the orderer will be created by the admin from the orderer organization
# NOTE: The identity performing the register request must be currently enrolled

usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./09_enroll_orderer-node.sh <ORDERER_NAME>  [ORDERER_PW , default=pw] [ORG_NAME , default=orderer] [<ORG-ADMIN-HOSTNAME , default=msp-admin-orderer]"
    echo "   ex: ./09_enroll_orderer-node.sh orderer-node pw orderer msp-admin-orderer"
    echo "   ex: ./09_enroll_orderer-node.sh orderer-node "
    echo "------------------------------------------------------------------------"
    exit
}

if [ -z $1 ]; then
    echo "Provide Orderer-node Name!!!"
    usage
else
    ORDERER_NAME=$1
    echo "Switching ORDERER_NAME to $ORDERER_NAME"
fi

if [ -z $2 ]; then
    ORDERER_PW=pw
    echo "ORDERER_PW=$ORDERER_PW"
else
    ORDERER_PW=$2
fi

if [ -z $3 ]; then
    ORG_NAME="orderer"
    echo "ORG_NAME=$ORG_NAME"
else
    ORG_NAME=$3
fi

if [ -z $4 ]; then
    CA_ORG_ADMIN_HOSTNAME="msp-admin-orderer"
    echo "CA_ORG_ADMIN_HOSTNAME=$CA_ORG_ADMIN_HOSTNAME"
else
    CA_ORG_ADMIN_HOSTNAME=$4
fi
################################################################################################
CA_SERVER_HOST_IP=192.168.1.10

SOURCE_CA_CLIENT_CONFIG_FILE="$BASE_CONFIG_FILES/fabric-ca-client-config-$ORDERER_NAME.yaml"
# records the FABRIC_CA_CLIENT_HOME of the orderer admin
ADMIN_CLIENT_HOME=$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/admin

echo "##############################################################"
echo "ADMIN_CLIENT_HOME: $ADMIN_CLIENT_HOME"
echo "##############################################################"
################################################################################################
# Set the FABRIC_CA_CLIENT_HOME for orderer
IDENTITY=$ORDERER_NAME

. ./set-ca-client.sh  $ORG_NAME admin
echo "checking FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"

# previous without set-ca-client.sh:  
#echo "changing identity to [$IDENTITY]"
#CA_CLIENT_FOLDER="$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/$IDENTITY"
#echo "my FABRIC_CA_CLIENT_HOME: $FABRIC_CA_CLIENT_HOME"
#export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER"
#echo "now FABRIC_CA_CLIENT_HOME: $FABRIC_CA_CLIENT_HOME"
################################################################################################
# Copy the client config yaml file
if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE" ]; then 
    echo "Using $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE for $ORG_NAME / $IDENTITY"
else
    echo "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE not found in $FABRIC_CA_CLIENT_HOME/"
    echo "creating : mkdir -p $FABRIC_CA_CLIENT_HOME " 
    mkdir -p $FABRIC_CA_CLIENT_HOME

    echo "Copy Yaml from: $SOURCE_CA_CLIENT_CONFIG_FILE"
    echo "cp $SOURCE_CA_CLIENT_CONFIG_FILE  $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"
    cp $SOURCE_CA_CLIENT_CONFIG_FILE $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE

    echo "checking with: ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"
    ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE
    if [ `echo $?` = 0 ]; then 
        echo "File $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE found."; 
    else 
        echo "ERROR: file $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE not found!";
        exit 
    fi
fi
################################################################################################
# enroll Admin Orderer
# Admin will  enroll the orderer identity. 
# The MSP will be written in the FABRIC_CA_CLIENT_HOME
# which was set to" FABRIC_CA_CLIENT_HOME/orderer/orderer" at lines 41-43
echo "###################################"
echo "# Enrolling: orderer"
echo "###################################"
echo "enrolling :=> fabric-ca-client enroll -u http://$ORDERER_NAME:$ORDERER_PW@$CA_SERVER_HOST_IP:7054"
fabric-ca-client enroll -u http://$ORDERER_NAME:$ORDERER_PW@$CA_SERVER_HOST_IP:7054
echo "======Completed: Step 2 : Enrolled orderer ========"

################################################################################################
# Step-3 Copy the admincerts to the appropriate folder
# NOTE: $FABRIC_CA_CLIENT_HOME/orderer/orderer-node
# NOTE: $ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/orderer/admin 
# at this point FABRIC_CA_CLIENT_HOME and CA_CLIENT_FOLDER must be the same

echo "###################################"
echo "# Setting up admincerts"
echo "###################################"

################################################################################################
# echo "DEBUG-ONLY: $FABRIC_CA_CLIENT_HOME == $CA_CLIENT_FOLDER ???"
if [ ! -d  $FABRIC_CA_CLIENT_HOME/msp/admincerts ]; then 
    echo "Creating $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
else
    echo "$FABRIC_CA_CLIENT_HOME/msp/admincerts already exists!!!"
fi
echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"

################################################################################################
#  Copying admincerts for user $IDENTITY from $ADMIN_CLIENT_HOME/msp/signcerts/ to  $FABRIC_CA_CLIENT_HOME/msp/admincerts"
# echo "cp $ADMIN_CLIENT_HOME/msp/signcerts/* $FABRIC_CA_CLIENT_HOME/msp/admincerts"
# cp $ADMIN_CLIENT_HOME/msp/signcerts/* $FABRIC_CA_CLIENT_HOME/msp/admincerts

ADMIN_CERTS_DIR="$ADMIN_CLIENT_HOME/msp/signcerts"
echo "Copying [$ADMIN_CERTS_DIR] from host [$CA_ORG_ADMIN_HOSTNAME] here at [$FABRIC_CA_CLIENT_HOME/msp/admincerts]"

echo "Getting orderer-admin certs with SCP"
echo "scp $CA_ORG_ADMIN_HOSTNAME:$ADMIN_CERTS_DIR/* $FABRIC_CA_CLIENT_HOME/msp/admincerts"
scp $CA_ORG_ADMIN_HOSTNAME:$ADMIN_CERTS_DIR/* $FABRIC_CA_CLIENT_HOME/msp/admincerts

################################################################################################
echo "Checking result with: ls $FABRIC_CA_CLIENT_HOME/msp/admincerts/"
ls $FABRIC_CA_CLIENT_HOME/msp/admincerts/
if [ `echo $?` = 0 ]; then 
    echo "File(s) found at $FABRIC_CA_CLIENT_HOME/msp/admincerts/."; 
else 
    echo "File(s) NOT found at $FABRIC_CA_CLIENT_HOME/msp/admincerts/ !";
fi
################################################################################################
echo "Done MSP setup for the orderer"