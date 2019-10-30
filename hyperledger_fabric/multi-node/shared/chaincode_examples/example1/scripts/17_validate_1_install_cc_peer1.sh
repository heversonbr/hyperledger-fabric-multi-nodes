# Test case #2 for validating the setup
# Requires: Orderer, org1 peer1 & org1 peer2 to be available
# Install the chaincode on peers. Instantiate on one of the peers
# Now invoke on one peer & query the status on the other peer to 
# validate consistency of the reported state.
#
# 1. Installs the CC to peer1 & peer2
# 2. Instantiates CC on peer1
# 3. Executes query on peer2
# 4. Executes invoke on peer1
# 5. Executes query on peer2
#
# NOTE: The peer chaincode subcommand ALLOWS ADMINISTRATORS to perform chaincode 
# related operations ON A PEER, such as installing, instantiating, invoking, packaging, querying, and upgrading chaincode.

function usage {
    echo "USAGE: "     
    echo "ex:   ./17_validate_1_install_cc_peer1.sh <ORG_NAME> <PEER_NAME> [<PEER_IP_ADDRESS>, default=192.168.1.15  [PORT_BASE_NUMBER default=7050]"
    echo "      ./17_validate_1_install_cc_peer1.sh  org1   peer1   192.168.1.15"
    echo "      ./17_validate_1_install_cc_peer1.sh  org1   peer1"
}

if [ -z $1 ]
then
    usage
    exit 1
else 
    ORG_NAME=$1
fi

if [ -z $2 ]
then
    usage
    exit 1
else 
    PEER_NAME=$2
fi

if [ -z $3 ]
then
    PEER_IP_ADDRESS=192.168.1.15
else 
    PEER_IP_ADDRESS=$3
fi

if [ -z $4 ]
then
    PEER_BASE_PORT=7050
else 
    PEER_BASE_PORT=$4
fi


##############################################################
CC_CONSTRUCTOR='{"Args":["init","a","100","b","200"]}'
CC_NAME="gocc" 
CC_PATH="example1/"
CC_VERSION="1.0"
CC_CHANNEL_ID="mychannelid"
##############################################################
IDENTITY="admin"

echo "creating dir $GOPATH/src/$CC_PATH"
mkdir -p $GOPATH/src/$CC_PATH
echo "cp ../src/*  $GOPATH/src/$CC_PATH/"
cp ../src/*  $GOPATH/src/$CC_PATH

# 1. Install CC
echo "##########################################################################"
echo "ORG_NAME: $ORG_NAME, PEER_NAME: $PEER_NAME, PEER_IP_ADDRESS: $PEER_IP_ADDRESS , PEER_BASE_PORT: $PEER_BASE_PORT, IDENTITY: $IDENTITY"
##############################################################
. $HYPERLEDGER_HOME/setup_scripts/set-peer-env.sh $ORG_NAME $PEER_NAME $PEER_IP_ADDRESS $PEER_BASE_PORT admin

echo "########################## DEBUG ONLY #####################################"
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

echo "====> 1. Installing chaincode on $PEER_NAME"
echo "peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION"
peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION
