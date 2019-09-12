# This script simply submits the channel create transaction transaction

usage(){
    echo "-------------------------------------------------------------"
    echo "USAGE: ./10_submit-create-channel.sh  <ORG_NAME> <IDENTITY> [IDENTITY default=admin]  [ORDERER_ADDRESS=192.168.1.10:7050]"
    echo "   ex: ./10_submit-create-channel.sh bcom admin"
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

echo "Using identity: $IDENTITY and org-name: $ORG_NAME"

# Orderer address
ORDERER_ADDRESS_PORT="192.168.1.13:7050"
echo "====>Using orderer: ORDERER_ADDRESS"

# TODO: make channelid and channel_tx_file  dynamic
CHANNELID=mychannelid
# Channel transaction file location
# The transaction should have been signed by one or more admins based on policy
# CHANNEL_TX_FILE="$PWD/../../orderer/multi-org-ca/airline-channel.tx"
CHANNEL_TX_FILE=$ORDERER_HOME/my-channel.tx 

# Sets the environment variables for the given identity
# source set-identity.sh

# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER="$HYPERLEDGER_HOME/ca-client"
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp

# Setup the MSP ID
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"
echo "Switched Identity to: $ORG_NAME   $IDENTITY"


# Submit the channel create transation
echo "#######################################"
echo "# Submit the channel create transation"
echo "########################################"
echo "peer channel create -o $ORDERER_ADDRESS_PORT -c $CHANNELID -f $CHANNEL_TX_FILE"
peer channel create -o $ORDERER_ADDRESS_PORT -c $CHANNELID -f $CHANNEL_TX_FILE
echo "########################################"
echo "====> Done. Check Orderer logs for any errors !!!"

















