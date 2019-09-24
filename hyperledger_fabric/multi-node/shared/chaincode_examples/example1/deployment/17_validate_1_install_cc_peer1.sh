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

CC_CONSTRUCTOR='{"Args":["init","a","100","b","200"]}'
CC_NAME="gocc"
CC_PATH="../src/chaincode_example1"
CC_VERSION="1.0"
CC_CHANNEL_ID="mychannelid"

ORG_NAME="org1"
IDENTITY="admin"

# 1. Install CC
PEER_NAME="peer1"
PEER_ADD="192.168.1.15"
PEER_BASE_PORT=7050
echo "====> 1   Installing chaincode (may fail if CC/version already there) on $PEER_NAME"
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION