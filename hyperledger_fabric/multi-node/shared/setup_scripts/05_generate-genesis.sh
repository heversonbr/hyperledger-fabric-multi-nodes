# Generates the orderer | generate genesis block for a channel 
# #export ORDERER_GENERAL_LOGLEVEL=debug
# export FABRIC_LOGGING_SPEC=INFO
# export FABRIC_CFG_PATH=$PWD

GENESIS_BLK_NAME=my_genesis.block
PROFILE=MyOrdererGenesisProfile  
CHANNELID=ordererchannel
# profile in configtx.yaml

OUTBLOCK=$ORDERER_HOME/$GENESIS_BLK_NAME

echo "FABRIC_LOGGING_SPEC: $FABRIC_LOGGING_SPEC"
echo "FABRIC_CFG_PATH : $FABRIC_CFG_PATH"

# --- 1) Copy config files
if [ -d $ORDERER_HOME ]; then
    echo "orderer folder exists, cleaning it"
    rm -Rf $ORDERER_HOME
    mkdir -p $ORDERER_HOME
else
    echo "orderer folder does not exist, creating it"
    mkdir -p $ORDERER_HOME
fi

cp $FABRIC_CONFIG_FILES/configtx.yaml $ORDERER_HOME/
cp $FABRIC_CONFIG_FILES/orderer-config.yaml $ORDERER_HOME/orderer.yaml
cp $FABRIC_CONFIG_FILES/core.yaml $ORDERER_HOME/
# ------------------------------

# --- 2) Generate-genesis.sh --- 

echo    '================ Writing the Genesis Block ================'
# Create the Genesis Block
configtxgen -profile $PROFILE -outputBlock $OUTBLOCK -channelID $CHANNELID
# profile : the profile from configtx.yaml
# outputBlock : the path to write the genesis block
# channelID  :  channel ID to use in the configtx
# ------------------------------