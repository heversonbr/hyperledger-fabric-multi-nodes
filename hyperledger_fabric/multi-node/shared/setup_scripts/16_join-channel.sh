# Joins the peer to a channel
# ORG_NAME="${PWD##*/}"

function usage {
    echo "Usage:"     
    echo "  ./16_join-channel.sh <CHANNEL_ID> <ORG_NAME> <PEER_NAME> <PEER_IP> [ORDERER_IP_ADDRESS default=192.168.1.14] [PORT_NUMBER default=7050]"
    echo "EX:./16_join-channel.sh mychannelid org1 peer1 192.168.1.15"
    echo "   Specified Peer MUST be up for the command to be successful"
}

if [ -z $1 ]
then
    usage
    echo 'Provide CHANNEL_ID, ORG_NAME , PEER_NAME!!!'
    exit 1
else 
    CHANNELID=$1
fi

if [ -z $2 ]
then
    usage
    echo 'Provide ORG_NAME, PEER_NAME!!!'
    exit 1
else 
    ORG_NAME=$2
fi

if [ -z $3 ]
then
    usage
    echo 'Provide PEER_NAME!!!'
    exit 1
else 
    PEER_NAME=$3
fi

if [ -z $4 ]
then
    usage
    echo 'Provide PEER_IP!!!'
    exit 1
else 
    PEER_IP=$4
fi
echo "====>Using peer IP: $PEER_IP"


if [ -z $5 ]
then
    ORDERER_IP="192.168.1.14"
else 
    ORDERER_IP=$5
fi
echo "====>Using orderer IP: $ORDERER_IP"


if [ -z $6 ]
then
    PORT_NUMBER=7050
else 
    PORT_NUMBER=$6
fi
echo "====>Using Port Number $PORT_NUMBER"


ORDERER_ADDRESS=$ORDERER_IP:$PORT_NUMBER
echo "ORDERER_ADDRESS: $ORDERER_ADDRESS"
# Set the environment vars
# source set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER
echo "################## setting env vars ############################"
# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER="../../ca-client"
# CORE_PEER_MSPCONFIGPATH initialized below 
export FABRIC_CFG_PATH="$FABRIC_CFG_PATH/$ORG_NAME"
if [ ! -d $FABRIC_CFG_PATH ];then
    mkdir -p $FABRIC_CFG_PATH
fi
cp $BASE_CONFIG_FILES/core-$ORG_NAME-$PEER_NAME.yaml $FABRIC_CFG_PATH/core.yaml

# Capitalize the first letter of Org name e.g., acme => Acme  budget => Budget
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"

export NODECHAINCODE="$FABRIC_CFG_PATH/nodechaincode"
export CORE_PEER_FILESYSTEM_PATH="/var/ledgers/$ORG_NAME/$PEER_NAME/ledger" 

# This is to avoid Port Number contention
VAR=$((PORT_NUMBER+1))
export CORE_PEER_LISTENADDRESS=$PEER_IP:$VAR
export CORE_PEER_ADDRESS=$PEER_IP:$VAR
VAR=$((PORT_NUMBER+2))
export CORE_PEER_CHAINCODELISTENADDRESS=$PEER_IP:$VAR
VAR=$((PORT_NUMBER+3))
export CORE_PEER_EVENTS_ADDRESS=$PEER_IP:$VAR
# All Peers will connect to this - peer 
export CORE_PEER_GOSSIP_BOOTSTRAP=$PEER_IP:7051

export PEER_LOGS=$FABRIC_CFG_PATH/$ORG_NAME/$PEER_NAME
echo "CORE_PEER_LOCALMSPID: $CORE_PEER_LOCALMSPID"
echo "NODECHAINCODE: $NODECHAINCODE "
echo "CORE_PEER_FILESYSTEM_PATH: $CORE_PEER_FILESYSTEM_PATH "
echo "CORE_PEER_LISTENADDRESS: $CORE_PEER_LISTENADDRESS"
echo "CORE_PEER_ADDRESS: $CORE_PEER_ADDRESS"
echo "CORE_PEER_CHAINCODELISTENADDRESS: $CORE_PEER_CHAINCODELISTENADDRESS"
echo "CORE_PEER_EVENTS_ADDRESS: $CORE_PEER_EVENTS_ADDRESS"
echo "CORE_PEER_GOSSIP_BOOTSTRAP: $CORE_PEER_GOSSIP_BOOTSTRAP"
echo "PEER_LOGS: $PEER_LOGS"
echo "################################################################"

# Only admin is allowed to execute join command
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/admin/msp
echo "Peer will use CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH"
echo "Peer will use FABRIC_CFG_PATH=$FABRIC_CFG_PATH"
echo "################################################################"
OUTPUT_FETCHED_CHANNEL_BLOCK=./myconfigchannel.block
# CHANNELID=mychannelid (1st argument)

echo "################################################################"
# Fetch channel configuration
# Fetch a specified block, writing it to a file.
peer channel fetch 0 $OUTPUT_FETCHED_CHANNEL_BLOCK -o $ORDERER_ADDRESS -c $CHANNELID
echo "################################################################"
# Join the channel
peer channel join -o $ORDERER_ADDRESS -b $OUTPUT_FETCHED_CHANNEL_BLOCK
# Execute the anchor peer update
echo "################################################################"