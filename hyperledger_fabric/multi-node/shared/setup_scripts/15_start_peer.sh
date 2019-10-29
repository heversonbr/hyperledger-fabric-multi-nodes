#!/bin/bash

function usage {
    echo "  Sets the environment variables for the peer & then launches it"
    echo "  Exs:"
    echo "   ./15_start_peer.sh  <org_name> <peer_name> [<PEER_IP_ADDRESS> default=localhost] [<PORT_NUMBER> default=7050] [IDENTITY default=peer_name]"
    echo "   ./15_start_peer.sh  org1 peer1 192.168.1.15"
    echo "   ./15_start_peer.sh  org1 peer2 192.168.1.17"
    echo "   ./15_start_peer.sh  org2 peer1 192.168.1.16"
    echo "   ./15_start_peer.sh  org2 peer2 192.168.1.18"
}


echo "Current PEER_NAME: $CORE_PEER_ID"
if [ -z $1 ]; then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
    echo "Switching PEER_NAME for Org = $ORG_NAME"
fi

if [ -z $2 ]; then
    usage
    echo  "Please specify PEER_NAME or Peer name!!!"
    exit 0
else
    PEER_NAME=$2
fi

if [ -z $3 ]; then
    echo "Setting PEER_IP_ADD=localhost"
    PEER_IP_ADD="localhost"
else
    PEER_IP_ADD=$3
fi

PORT_NUMBER_BASE=7050
if [ -z $4 ]; then
    echo "Using PORT_NUMBER_BASE=$PORT_NUMBER_BASE"   
else
    PORT_NUMBER_BASE=$4
fi

export CORE_PEER_ID=$PEER_NAME

if [ -z $5 ]; then
    echo "IDENTITY=$PEER_NAME"
    IDENTITY=$PEER_NAME
else
    IDENTITY=$5
    
fi

echo "##################################"
echo "PEER_NAME: $PEER_NAME"
echo "IDENTITY: $IDENTITY"
echo "CORE_PEER_ID: $CORE_PEER_ID"
echo "##################################"

################################################################################################
# Set up the environment variables
# this is important for all peers related scripts 
# NOTE: FABRIC_CFG_PATH is set in set-env.sh below 
#       FABRIC_CFG_PATH="$FABRIC_CFG_PATH/$ORG_NAME/$PEER_NAME"

# source set-env.sh
########################## SETTING VARS #####################################################################


. ./set-peer-env.sh  $ORG_NAME $PEER_NAME $PEER_IP_ADD $PORT_NUMBER_BASE $IDENTITY


./list_env_vars.sh
##########################################################################################################

# Create the ledger folders
# To retain the environment vars we need to use -E flag with sudo
# sudo -E mkdir -p $CORE_PEER_FILESYSTEM_PATH

# Create the folder for the logs
mkdir -p $PEER_LOGS

cp $BASE_CONFIG_FILES/core-$ORG_NAME-$PEER_NAME.yaml  $FABRIC_CFG_PATH/core.yaml

# Start the peer
sudo -E $HYPERLEDGER_HOME/bin/peer node start 2> $PEER_LOGS/peer.log &
##########################################################################################################
echo "###################################################"
echo "PLEASE Check Peer Log under $PEER_LOGS/peer.log"
echo "###################################################"
# sleep 3
# cat "$PEER_LOGS/peer.log"
echo "######################################################################################"
echo "NOTE: Make sure there are no errors at $PEER_LOGS/peer.log !!!"
echo "      use  ./set-peer-env.sh to set the env variables for this peer"
echo "      use  ./set-indentity.sh to set the identity used for executing the peer commands"
echo "######################################################################################"