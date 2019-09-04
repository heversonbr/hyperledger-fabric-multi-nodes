# Generates the orderer | generate genesis block for a channel 
# #export ORDERER_GENERAL_LOGLEVEL=debug
# export FABRIC_LOGGING_SPEC=INFO
# export FABRIC_CFG_PATH=$PWD

GENESIS_BLK_NAME=my_genesis.block
PROFILE=MyOrdererGenesisProfile
CHANNELID=ordererchannel

OUTBLOCK=$FABRIC_ORDERER_HOME/$GENESIS_BLK_NAME

# --- 1) Copy config files
if [ -d $FABRIC_ORDERER_HOME ]; then
    echo "orderer folder exists, cleaning it"
    rm -Rf $FABRIC_ORDERER_HOME
    mkdir -p $FABRIC_ORDERER_HOME
else
    echo "orderer folder does not exist, creating it"
    mkdir -p $FABRIC_ORDERER_HOME
fi

cp $FABRIC_CONFIG_FILES/configtx.yaml $FABRIC_ORDERER_HOME/
cp $FABRIC_CONFIG_FILES/orderer-config.yaml $FABRIC_ORDERER_HOME/orderer.yaml
# ------------------------------

# --- 2) Generate-genesis.sh --- 

echo    '================ Writing the Genesis Block ================'
# Create the Genesis Block
configtxgen -profile $PROFILE -outputBlock $OUTBLOCK -channelID $CHANNELID
# profile : the profile from configtx.yaml
# outputBlock : the path to write the genesis block
# channelID  :  channel ID to use in the configtx
# ------------------------------