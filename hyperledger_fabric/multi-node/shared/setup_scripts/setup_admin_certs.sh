#!/bin/bash

# makes the final set up
# Creates the admincerts folder and copies the admin's cert to 
# admincerts folder
# run this script from the msp hosts at the organizations


usage(){
    echo "-------------------------------------------------------------"
    echo "USAGE: ./setup_admin_certs.sh <org_name> <admin_certs_host>"
    echo "   EX: ./setup_admin_certs.sh acme "
    echo "-------------------------------------------------------------"
    exit
}


if [ $# -ne 2 ]; then
    usage
fi

ORG_NAME=$1
ADMIN_CERTS_HOST=$2

ADMIN_CERTS_DIR="/home/ubuntu/hyperledger_ws/ca-client/caserver/admin/msp/signcerts"

SUBDIR=$ORG_NAME/admin
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "my FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"


### setupMSP ### 
if [ ! -d  $FABRIC_CA_CLIENT_HOME/msp/admincerts ]; then 
    echo "Creating $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
else
    echo "$FABRIC_CA_CLIENT_HOME/msp/admincerts already exists!!!"
fi
echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"

echo "copying $ADMIN_CERTS_DIR/*  to $FABRIC_CA_CLIENT_HOME/msp/admincerts"
if [ ! -d $ADMIN_CERTS_DIR ]; then
    echo "directory $ADMIN_CERTS_DIR does not exist locally"
    echo "getting admin certs using scp"
    echo "scp $ADMIN_CERTS_HOST:$ADMIN_CERTS_DIR/* $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    scp $ADMIN_CERTS_HOST:$ADMIN_CERTS_DIR/* $FABRIC_CA_CLIENT_HOME/msp/admincerts
    ls -al $FABRIC_CA_CLIENT_HOME/msp/admincerts
else
    # this is the default way of doing it locally using different directories
    echo "directory $ADMIN_CERTS_DIR does exist locally, copying from it"
    cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
    ls -al $FABRIC_CA_CLIENT_HOME/msp/admincerts
fi
# cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
# ls -al $FABRIC_CA_CLIENT_HOME/msp/admincerts


### Setup MSP for Orgs ###
# Path to the CA certificate
ROOT_CA_CERTIFICATE=$FABRIC_CA_SERVER_HOME/ca-cert.pem
# Parent folder for the MSP folder
DESTINATION_CLIENT_HOME="$FABRIC_CA_CLIENT_HOME/.."


# Create the MSP subfolders
mkdir -p $DESTINATION_CLIENT_HOME/msp/admincerts 
mkdir -p $DESTINATION_CLIENT_HOME/msp/cacerts 
mkdir -p $DESTINATION_CLIENT_HOME/msp/keystore

if [ ! -f $ROOT_CA_CERTIFICATE ] ; then 
    echo "root certificate does NOT exist at $ROOT_CA_CERTIFICATE"
    # Copy the Root CA Cert
    echo "scp $ADMIN_CERTS_HOST:$ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts"
    scp $ADMIN_CERTS_HOST:$ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts

    # Copy the admin certs - ORG admin is the admin for the specified Org
    cp $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts 


else
    echo "root certificate exists at $ROOT_CA_CERTIFICATE"
fi

## Copy the Root CA Cert
#cp $ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts
#
## Copy the admin certs - ORG admin is the admin for the specified Org
#cp $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts 

echo "Created MSP at: $DESTINATION_CLIENT_HOME"

echo "-------------- showing identities ----------------------"
fabric-ca-client identity list
echo "--------------------------------------------------------"
echo "Done MSP setup for org: $ORG_NAME"