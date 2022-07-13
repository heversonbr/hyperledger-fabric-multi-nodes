#!/bin/bash

# Sets the env & identity to specified Org User

function usage {
    echo "Description:  Sets the environment variables for the peer that need to be administered"
    echo "Usage: "
    echo "     . ./set-peer-env.sh <ORG_NAME> <PEER_NAME> <PEER_IP_ADDRESS> <PORT_NUMBER> <IDENTITY>"
    echo "Ex: "
    echo "     .  ./set-peer-env.sh   org1   peer1   192.168.1.15   7050   peer1"
    echo "     .  ./set-peer-env.sh   org1   peer2   192.168.1.17   7050   peer2"

}

echo "Current PEER_NAME: $CORE_PEER_ID"

if [ -z $1 ];then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

if [ -z $2 ];then
    usage
    echo  "Please provide PEER_NAME"
    exit 0
else
    PEER_NAME=$2
fi

if [ -z $3 ];then
    usage
    echo  "Please provide PEER_IP_ADD"
    exit 0
else
    PEER_IP_ADD=$3
fi

if [ -z $4 ];then
    usage
    echo  "Please provide PORT_NUMBER"
    exit 0
else
    PORT_NUMBER_BASE=$4
fi

export CORE_PEER_ID=$PEER_NAME

if [ -z $5 ];then
    usage
    echo  "Please provide PEER_NAME"
    exit 0
else
    IDENTITY=$5
    
fi
################################################################################################
echo "############# DEBUG #####################"
echo "PEER_NAME: $PEER_NAME"
echo "IDENTITY: $IDENTITY"
echo "CORE_PEER_ID: $CORE_PEER_ID"
echo "#########################################"
################################################################################################

# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER=$BASE_FABRIC_CA_CLIENT_HOME
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp
export FABRIC_CFG_PATH="$BASE_FABRIC_CFG_PATH/$ORG_NAME/$PEER_NAME"
export MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"
export NODECHAINCODE="$FABRIC_CFG_PATH/nodechaincode"
export CORE_PEER_FILESYSTEM_PATH="/var/ledgers/$ORG_NAME/$PEER_NAME/ledger" 
# This is to avoid Port Number contention
VAR=$((PORT_NUMBER_BASE+1))
export CORE_PEER_LISTENADDRESS=$PEER_IP_ADD:$VAR
export CORE_PEER_ADDRESS=$PEER_IP_ADD:$VAR
VAR=$((PORT_NUMBER_BASE+2))
export CORE_PEER_CHAINCODELISTENADDRESS=$PEER_IP_ADD:$VAR
VAR=$((PORT_NUMBER_BASE+3))
export CORE_PEER_EVENTS_ADDRESS=$PEER_IP_ADD:$VAR
export CORE_PEER_GOSSIP_BOOTSTRAP=$PEER_IP_ADD:7051
export PEER_LOGS=$FABRIC_CFG_PATH
################################################################################################
echo "########################### SET PEER ENV ###################################"
echo "CRYPTO_CONFIG_ROOT_FOLDER: $CRYPTO_CONFIG_ROOT_FOLDER"
echo "CORE_PEER_MSPCONFIGPATH: $CORE_PEER_MSPCONFIGPATH"
echo "FABRIC_CFG_PATH: $FABRIC_CFG_PATH"
echo "CORE_PEER_LOCALMSPID: $CORE_PEER_LOCALMSPID"
echo "MSP_ID: $MSP_ID" 
echo "CORE_PEER_LOCALMSPID: $CORE_PEER_LOCALMSPID" 
echo "NODECHAINCODE: $NODECHAINCODE" 
echo "CORE_PEER_FILESYSTEM_PATH: $CORE_PEER_FILESYSTEM_PATH"  
echo "CORE_PEER_LISTENADDRESS: $CORE_PEER_LISTENADDRESS" 
echo "CORE_PEER_ADDRESS: $CORE_PEER_ADDRESS" 
echo "CORE_PEER_CHAINCODELISTENADDRESS: $CORE_PEER_CHAINCODELISTENADDRESS" 
echo "CORE_PEER_EVENTS_ADDRESS: $CORE_PEER_EVENTS_ADDRESS" 
echo "CORE_PEER_GOSSIP_BOOTSTRAP: $CORE_PEER_GOSSIP_BOOTSTRAP"
echo "PEER_LOGS: $PEER_LOGS" 
echo "##########################################################################"

# Simply checks if this script was executed directly on the terminal/shell
# it has the '.'
if [[ $0 = *"set-env.sh" ]]
then
    echo "Did you use the . before ./set-env.sh? If yes then we are good :)"
fi