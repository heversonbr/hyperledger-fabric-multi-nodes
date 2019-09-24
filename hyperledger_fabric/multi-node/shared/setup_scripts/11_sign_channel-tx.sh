#!/bin/bash

# Sign the channel tx file org admins
# E.g.,   ./sign-channel-tx.sh   org1  Signs the file with org1 admin certificate/key
# E.g.,   ./sign-channel-tx.sh   org2  Signs the file with org2 admin certificate/key
function usage {
    echo " Signs the channel transaction file with identity of admin"
    echo "USAGE:  ./11_sign_channel-tx.sh ORG_NAME"
    echo "Exs:    ./11_sign_channel-tx.sh orderer    : Signs the file with orderer admin certificate/key"
    echo "        ./11_sign_channel-tx.sh org1       : Signs the file with org1 admin certificate/key"

}

if [ -z $1 ]
then
    usage
    echo 'Please provide ORG_NAME!!!'
    exit 1
else 
    ORG_NAME=$1
fi

echo "FABRIC_CFG_PATH: $FABRIC_CFG_PATH"
if [ ! -d $FABRIC_CFG_PATH ]; then
    echo "$FABRIC_CFG_PATH folder does not exist, creating it."
    mkdir -p $FABRIC_CFG_PATH
fi

cp $BASE_CONFIG_FILES/core-orderer-node.yaml $FABRIC_CFG_PATH/core.yaml


ORDERER_ADMIN_HOSTNAME=msp-admin-orderer

# Variable holds path to the channel tx file
CHANNEL_TX_FILE=$FABRIC_CFG_PATH/my-channel.tx
echo "CHANNEL_TX_FILE: $CHANNEL_TX_FILE"
if [ ! -f $CHANNEL_TX_FILE ]; then
    echo "File $CHANNEL_TX_FILE does not exist locally. (running from OTHER than orderer?)"
    echo "Getting CHANNEL_TX_FILE from orderer using scp"
    echo "scp ubuntu@$ORDERER_ADMIN_HOSTNAME:$FABRIC_CFG_PATH/my-channel.tx $FABRIC_CFG_PATH/"
    scp ubuntu@$ORDERER_ADMIN_HOSTNAME:$FABRIC_CFG_PATH/my-channel.tx $FABRIC_CFG_PATH/
else 
    echo "File $CHANNEL_TX_FILE exists locally. (running from ORDERER?)"
fi



IDENTITY="admin"
# Set the environment variable $1 = ORG_NAME Identity=admin
# source set-identity.sh (lines 24 to 33 come from set-identity)
# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER=$BASE_FABRIC_CA_CLIENT_HOME
echo "CRYPTO_CONFIG_ROOT_FOLDER: $CRYPTO_CONFIG_ROOT_FOLDER"

export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp
echo "CORE_PEER_MSPCONFIGPATH: $CORE_PEER_MSPCONFIGPATH"

# Setup the MSP ID
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"
echo "CORE_PEER_LOCALMSPID: $CORE_PEER_LOCALMSPID"
echo "Switched Identity to: $ORG_NAME   $IDENTITY"
echo "---------------------------------------"
ls -al $CHANNEL_TX_FILE
echo "---------------------------------------"
# Execute command to sign the tx file in place
echo "running: peer channel signconfigtx -f $CHANNEL_TX_FILE"
peer channel signconfigtx -f $CHANNEL_TX_FILE

echo "====> Done. Signed file with identity $ORG_NAME/admin"
echo "====> Check size & timestamp of file $CHANNEL_TX_FILE"
echo "---------------------------------------"
ls -al $CHANNEL_TX_FILE
echo "---------------------------------------"
# NOTE: The join cannot be execute without a channel created
# peer channel join -o <PEER_IP>:7050 -b my-channel.tx