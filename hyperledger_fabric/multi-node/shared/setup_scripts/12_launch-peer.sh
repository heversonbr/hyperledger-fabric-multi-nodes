#!/bin/bash

function usage {
    echo "  Sets the environment variables for the peer & then launches it"
    echo " "
    echo ". ./launch-peer.sh <org_name> <peer_name> [<PEER_IP_ADDRESS> default=localhost] [<PORT_NUMBER> default=7050] "
    exit
}

# Org name Must be provided
if [ -z $1 ];
then
    echo "Please provide the ORG Name!!!"
    usage
else
    ORG_NAME=$1
fi

# Peer name Must be provided
if [ -z $2 ];
then
    echo  "Please specify PEER_NAME!!!"
    usage
else 
    PEER_NAME=$2
fi


# Set up the environment variables
source set-env.sh
./list_env_vars.sh

# export CORE_PEER_FILESYSTEMPATH="/var/ledgers/$ORG_NAME/$PEER_NAME/ledger" 

# Create the ledger folders
# To retain the environment vars we need to use -E flag with sudo
#sudo -E mkdir -p $CORE_PEER_FILESYSTEMPATH
sudo -E mkdir -p $CORE_PEER_FILESYSTEM_PATH

# Create the folder for the logs
mkdir -p $PEER_LOGS
cp $BASE_CONFIG_FILES/core-$ORG_NAME-$PEER_NAME.yaml   $FABRIC_CFG_PATH/core.yaml

# Start the peer
sudo -E $HYPERLEDGER_HOME/bin/peer node start 2> $PEER_LOGS/peer.log &

echo "====>PLEASE Check Peer Log under $PEER_LOGS/peer.log"
echo "###################################################"
cat $PEER_LOGS/peer.log
echo "###################################################"
echo "====>Make sure there are no errors!!!"