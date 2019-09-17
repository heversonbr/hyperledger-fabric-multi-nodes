# This script simply submits the channel create transaction transaction

usage(){
    echo "-------------------------------------------------------------"
    echo "USAGE: ./10_submit-create-channel.sh  <ORG_NAME> <IDENTITY> [IDENTITY default=admin]  [ORDERER_ADDRESS default=192.168.1.14] [ORDERER_PORT default=7050]"
    echo "   ex: ./10_submit-create-channel.sh org1 admin"
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


echo "Using identity: $IDENTITY and org-name: $ORG_NAME"

# Orderer address
ORDERER_ADDRESS_PORT="$ADD:$PORT"
echo "====> Using orderer: $ORDERER_ADDRESS_PORT"

ORDERER_FABRIC_CFG_PATH=$FABRIC_CFG_PATH/orderer

export FABRIC_CFG_PATH="$FABRIC_CFG_PATH/$ORG_NAME/$IDENTITY"

# TODO: make channelid and channel_tx_file  dynamic
CHANNELID=mychannelid
# Channel transaction file location
# The transaction should have been signed by one or more admins based on policy
# As we are doing the submit creation from a peer in a org and the channel was created
# by the orderer we need to copy the channel transaction from the orderer.
CHANNEL_TX_FILE=$FABRIC_CFG_PATH/my-channel.tx 
echo "#######################################################################"
echo "getting CHANNEL_TX_FILE from orderer using scp"
echo "scp ubuntu@$ADD:$ORDERER_FABRIC_CFG_PATH/my-channel.tx $CHANNEL_TX_FILE"
scp ubuntu@$ADD:$ORDERER_FABRIC_CFG_PATH/my-channel.tx $CHANNEL_TX_FILE
ls $CHANNEL_TX_FILE
if [ ! -f $CHANNEL_TX_FILE ]; then
    echo "$CHANNEL_TX_FILE not found."
fi
echo "#######################################################################"


# Sets the environment variables for the given identity
# source set-identity.sh

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


# Submit the channel create transation
echo "#######################################"
echo "# Submit the channel create transation"
echo "########################################"

echo "running: peer channel create -o $ORDERER_ADDRESS_PORT -c $CHANNELID -f $CHANNEL_TX_FILE"
peer channel create -o $ORDERER_ADDRESS_PORT -c $CHANNELID -f $CHANNEL_TX_FILE
echo "########################################"
echo "====> Done. Check Orderer logs for any errors !!!"

















