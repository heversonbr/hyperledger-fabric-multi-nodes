#!/bin/bash

# This script simply submits the channel create transaction transaction

usage(){
    echo "-------------------------------------------------------------"
    echo "USAGE: ./12_submit_create_channel.sh  <ORG_NAME> <IDENTITY> [IDENTITY default=admin]  [ORDERER_ADDRESS default=192.168.1.14] [ORDERER_PORT default=7050]"
    echo "   ex: ./12_submit_create_channel.sh  org1  admin"
    echo "-------------------------------------------------------------"
    exit
}

if [ -z $1 ]
then
    echo 'Please provide ORG_NAME!!!'
    usage
else 
    ORG_NAME=$1
fi

# Identity check
if [ -z $2 ]
then
    IDENTITY=admin
else 
    IDENTITY=$2
fi

# ORDERER IP ADD check
if [ -z $3 ]
then
    ADD="192.168.1.14"
else 
    ADD=$3
fi

# ORDERER PORT check
if [ -z $4 ]
then
    PORT="7050"
else 
    PORT=$4
fi
################################################################################################
echo "#######################################################################"
echo "Using identity: $IDENTITY and org-name: $ORG_NAME"

# Orderer address
ORDERER_ADDRESS_PORT="$ADD:$PORT"
ORDERER_ADMIN_HOSTNAME=msp-admin-orderer
echo "====> Using orderer: $ORDERER_ADDRESS_PORT"
CHANNELID=mychannelid
CHANNEL_TX_FILE=my-channel.tx 

################################################################################################
# Channel transaction file location
# The transaction should have been signed by one or more admins based on policy
# As we are doing the submit creation from a peer in a org and the channel was created
# by the orderer we need to copy the channel transaction from the orderer.
ORDERER_FABRIC_CFG_PATH=$FABRIC_CFG_PATH
echo "#######################################################################"
if [ $IDENTITY == "admin" ];then
    echo "running from the msp-admin-$ORG_NAME"
    echo "keeping FABRIC_CFG_PATH=$FABRIC_CFG_PATH"
else
    echo "running from the $IDENTITY host"
    echo "setting FABRIC_CFG_PATH=$FABRIC_CFG_PATH/$ORG_NAME/$IDENTITY"
    export FABRIC_CFG_PATH="$FABRIC_CFG_PATH/$ORG_NAME/$IDENTITY"
fi

if [ ! -d $FABRIC_CFG_PATH ]; then
    echo "creating $FABRIC_CFG_PATH"
    mkdir -p $FABRIC_CFG_PATH
fi
################################################################################################
echo "Getting CHANNEL_TX_FILE and core.yaml from orderer using scp"
echo "scp ubuntu@$ORDERER_ADMIN_HOSTNAME:$ORDERER_FABRIC_CFG_PATH/my-channel.tx $FABRIC_CFG_PATH/"
scp ubuntu@$ORDERER_ADMIN_HOSTNAME:$ORDERER_FABRIC_CFG_PATH/my-channel.tx $FABRIC_CFG_PATH/

# TODO: check if I really need to copy this core.yaml here!!!!
#echo "scp ubuntu@$ORDERER_ADMIN_HOSTNAME:$ORDERER_FABRIC_CFG_PATH/core.yaml $FABRIC_CFG_PATH/"
#scp ubuntu@$ORDERER_ADMIN_HOSTNAME:$ORDERER_FABRIC_CFG_PATH/core.yaml $FABRIC_CFG_PATH/
cp $BASE_CONFIG_FILES/core-orderer-node.yaml $FABRIC_CFG_PATH/core.yaml
################################################################################################

echo "#######################################################################"
# Sets the environment variables for the given identity
# source set-identity.sh
. ./set-identity.sh $ORG_NAME $IDENTITY

# Create the path to the crypto config folder
#CRYPTO_CONFIG_ROOT_FOLDER="$HYPERLEDGER_HOME/ca-client"
CRYPTO_CONFIG_ROOT_FOLDER=$BASE_FABRIC_CA_CLIENT_HOME
echo "CRYPTO_CONFIG_ROOT_FOLDER: $CRYPTO_CONFIG_ROOT_FOLDER"

export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp
echo "CORE_PEER_MSPCONFIGPATH: $CORE_PEER_MSPCONFIGPATH"

# Setup the MSP ID
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"
echo "Switched Identity to: $ORG_NAME   $IDENTITY"

################################################################################################
# Submit the channel create transation
# Channel transaction file location: CHANNEL_TX_FILE=my-channel.tx 
# The transaction should have been signed by one or more admins based on policy
echo "#######################################################################"
echo "# Submit the channel create transation"
echo "#######################################################################"

echo "running: peer channel create -o $ORDERER_ADDRESS_PORT -c $CHANNELID -f $FABRIC_CFG_PATH/$CHANNEL_TX_FILE"
peer channel create -o $ORDERER_ADDRESS_PORT -c $CHANNELID -f $FABRIC_CFG_PATH/$CHANNEL_TX_FILE
echo "#######################################################################"
echo "====> Done. Check Orderer logs for any errors !!!"

















