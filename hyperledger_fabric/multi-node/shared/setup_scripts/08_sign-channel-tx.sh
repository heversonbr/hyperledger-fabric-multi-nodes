# Sign the airline channel tx file org admins
# E.g.,   ./sign-channel-tx.sh   bcom       Signs the file with bcom admin certificate/key
# E.g.,   ./sign-channel-tx.sh   orange     Signs the file with orange admin certificate/key
function usage {
    echo "./sign-channel-tx.sh ORG_NAME"
    echo " Signs the channel transaction file with identity of admin from ORG_ADMIN"
    echo " NOTE: Signs the tx file under ./orderer/my-channel.tx "
}

if [ -z $1 ]
then
    usage
    echo 'Please provide ORG_NAME!!!'
    exit 1
else 
    ORG_NAME=$1
fi

# this is important for all orderer related scripts (the base FABRIC_CFG_PATH=$HYPERLEDGER_HOME/fabric)
export FABRIC_CFG_PATH=$FABRIC_CFG_PATH/orderer
echo "FABRIC_CFG_PATH: $FABRIC_CFG_PATH"
cp $BASE_CONFIG_FILES/core-orderer.yaml $FABRIC_CFG_PATH/core.yaml


# Variable holds path to the channel tx file
CHANNEL_TX_FILE=$FABRIC_CFG_PATH/my-channel.tx
echo "CHANNEL_TX_FILE: $CHANNEL_TX_FILE"

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


# Execute command to sign the tx file in place
echo "running: peer channel signconfigtx -f $CHANNEL_TX_FILE"
peer channel signconfigtx -f $CHANNEL_TX_FILE

echo "====> Done. Signed file with identity $ORG_NAME/admin"
echo "====> Check size & timestamp of file $CHANNEL_TX_FILE"
ls -al $CHANNEL_TX_FILE

# NOTE: The join cannot be execute without a channel created
# peer channel join -o localhost:7050 -b my-channel.tx