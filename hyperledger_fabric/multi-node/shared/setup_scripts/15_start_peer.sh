#!/bin/bash

function usage {
    echo "  Sets the environment variables for the peer & then launches it"
    echo "  Exs:"
    echo "   ./15_start_peer.sh  <org_name> <peer_name> [<PEER_IP_ADDRESS> default=localhost] [<PORT_NUMBER> default=7050] [IDENTITY default=peer-name]"
    echo "   ./15_start_peer.sh  org1 peer1 192.168.1.15"
    echo "   ./15_start_peer.sh  org1 peer2 192.168.1.17"
    echo "   ./15_start_peer.sh  org2 peer1 192.168.1.16"
    echo "   ./15_start_peer.sh  org2 peer2 192.168.1.18"

}

# Change this to appropriate level
# export CORE_LOGGING_LEVEL=info  #debug  #info #warning

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


# Set up the environment variables
# this is important for all peers related scripts 
# NOTE: FABRIC_CFG_PATH is set in set-env.sh below 
#       FABRIC_CFG_PATH="$FABRIC_CFG_PATH/$ORG_NAME/$PEER_NAME"

# source set-env.sh
########################## SETTING VARS #####################################################################
echo "##################################"
echo "PEER_NAME: $PEER_NAME"
echo "IDENTITY: $IDENTITY"
echo "CORE_PEER_ID: $CORE_PEER_ID"
echo "##################################"

# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER=$BASE_FABRIC_CA_CLIENT_HOME

# Capitalize the first letter of Org name
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp
export FABRIC_CFG_PATH="$FABRIC_CFG_PATH/$ORG_NAME/$PEER_NAME"
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
mkdir -p $PEER_LOGS
##########################################################################################################

./list_env_vars.sh
echo "################################################################"
echo "CRYPTO_CONFIG_ROOT_FOLDER: $CRYPTO_CONFIG_ROOT_FOLDER"
echo "CORE_PEER_MSPCONFIGPATH: $CORE_PEER_MSPCONFIGPATH"
echo "FABRIC_CFG_PATH: $FABRIC_CFG_PATH" 
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

# Create the ledger folders
# To retain the environment vars we need to use -E flag with sudo
# sudo -E mkdir -p $CORE_PEER_FILESYSTEM_PATH

# Create the folder for the logs

cp $BASE_CONFIG_FILES/core-$ORG_NAME-$PEER_NAME.yaml   $FABRIC_CFG_PATH/core.yaml

# Start the peer
sudo -E $HYPERLEDGER_HOME/bin/peer node start 2> $PEER_LOGS/peer.log &

echo "====>PLEASE Check Peer Log under $PEER_LOGS/peer.log"
echo "###################################################"
sleep 3
cat "$PEER_LOGS/peer.log"
echo "###################################################"
echo "====>Make sure there are no errors at $PEER_LOGS/peer.log !!!"