#!/bin/bash

# Sets the env & identity to specified   Org   User

# Extract name of the ORG from the folder name
#ORG_NAME="${PWD##*/}"
#ORG_PWD=`pwd`

function usage {
    echo ". set-env.sh <org_name> <peer_name> [<PEER_IP_ADDRESS> default=localhost] [<PORT_NUMBER> default=7050] [IDENTITY default=peer-name]"
    echo "  Sets the environment variables for the peer that need to be administered"
}

# Change this to appropriate level
#export CORE_LOGGING_LEVEL=info  #debug  #info #warning

echo "Current PEER_NAME: $CORE_PEER_ID"
if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
    echo "Switching PEER_NAME for Org = $ORG_NAME"
fi

if [ -z $2 ];
then
    usage
    echo  "Please specify PEER_NAME or Peer name!!!"
    exit 0
else
    PEER_NAME=$2
fi



if [ -z $3 ]
then
    echo "Setting PEER_IP_ADD=localhost"
    PEER_IP_ADD="localhost"
else
    PEER_IP_ADD=$3
fi

PORT_NUMBER_BASE=7050
if [ -z $4 ]
then
    echo "Setting PORT_NUMBER_BASE=7050"   
else
    PORT_NUMBER_BASE=$4
fi

export CORE_PEER_ID=$PEER_NAME

if [ -z $5 ]
then
    # do nothing
    echo "Identity=$PEER_NAME"
    IDENTITY=$PEER_NAME
else
    IDENTITY=$5
    
fi

echo "##################################"
echo "PEER_NAME: $PEER_NAME"
echo "IDENTITY: $IDENTITY"
echo "CORE_PEER_ID: $CORE_PEER_ID"
echo "##################################"

# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER=$BASE_FABRIC_CA_CLIENT_HOME
echo "CRYPTO_CONFIG_ROOT_FOLDER: $CRYPTO_CONFIG_ROOT_FOLDER"

export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp
echo "CORE_PEER_MSPCONFIGPATH: $CORE_PEER_MSPCONFIGPATH"

export FABRIC_CFG_PATH="$FABRIC_CFG_PATH/$ORG_NAME/$PEER_NAME"
echo "FABRIC_CFG_PATH: $FABRIC_CFG_PATH"

# Capitalize the first letter of Org name
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"
echo "CORE_PEER_LOCALMSPID: $CORE_PEER_LOCALMSPID"


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

# All Peers will connect to this - peer 
export CORE_PEER_GOSSIP_BOOTSTRAP=$PEER_IP_ADD:7051

export PEER_LOGS=$FABRIC_CFG_PATH


# Simply checks if this script was executed directly on the terminal/shell
# it has the '.'
if [[ $0 = *"set-env.sh" ]]
then
    echo "Did you use the . before ./set-env.sh? If yes then we are good :)"
fi