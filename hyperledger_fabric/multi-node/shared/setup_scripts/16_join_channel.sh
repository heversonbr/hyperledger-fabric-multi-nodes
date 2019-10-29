# Joins the peer to a channel
# ORG_NAME="${PWD##*/}"

function usage {
    echo "       Specified Peer MUST be up for the command to be successful"
    echo "       Usage: "     
    echo "       ./16_join_channel.sh <CHANNEL_ID> <ORG_NAME> <PEER_NAME> <PEER_IP> [ORDERER_IP_ADDRESS default=192.168.1.14] [PORT_NUMBER default=7050]"
    echo "ex:    ./16_join_channel.sh mychannelid   org1   peer1   192.168.1.15"
    echo "       ./16_join_channel.sh mychannelid   org1   peer2   192.168.1.17"
    
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
    echo 'Provide PEER_IP_ADD!!!'
    exit 1
else 
    PEER_IP_ADD=$4
fi
echo "====>Using peer IP: $PEER_IP_ADD"


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

##########################################################################################################
# Set the environment vars
# source set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER
echo "################## setting env vars ############################"

. ./set-peer-env.sh $ORG_NAME $PEER_NAME $PEER_IP_ADD $PORT_NUMBER admin

# Create the path to the crypto config folder
echo "current folder: $PWD"

if [ ! -d $FABRIC_CFG_PATH ];then
    mkdir -p $FABRIC_CFG_PATH
fi
cp $BASE_CONFIG_FILES/core-$ORG_NAME-$PEER_NAME.yaml $FABRIC_CFG_PATH/core.yaml

sudo mkdir -p $CORE_PEER_FILESYSTEM_PATH

./list_env_vars.sh



CHANNEL_BLOCK=$FABRIC_CFG_PATH/mychannel.block
echo "################################################################"
# Fetch channel configuration
# Fetch a specified block, writing it to a file.
peer channel fetch 0 $CHANNEL_BLOCK -o $ORDERER_ADDRESS -c $CHANNELID

echo "################################################################"
# Join the channel: Only admin is allowed to execute join command
peer channel join -o $ORDERER_ADDRESS -b $CHANNEL_BLOCK

echo "################################################################################"
echo "NOTE: Check orderer and peer logs! "
echo "      use ' peer channel list ' at the peers to check if they joined the channel"
echo "################################################################################"