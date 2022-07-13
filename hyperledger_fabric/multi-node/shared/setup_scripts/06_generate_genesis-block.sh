#!/bin/bash

# Generates genesis block for a channel 
# export ORDERER_GENERAL_LOGLEVEL=debug
# export FABRIC_LOGGING_SPEC=INFO
# this is important for all orderer related scripts (the base FABRIC_CFG_PATH=$HYPERLEDGER_HOME/fabric)
# export FABRIC_CFG_PATH=$FABRIC_CFG_PATH/orderer

GENESIS_BLK_NAME=my_genesis.block
CHANNELID=ordererchannel
PROFILE=MyOrdererGenesisProfile
# profile in configtx.yaml

OUTBLOCK=$FABRIC_CFG_PATH/$GENESIS_BLK_NAME
################################################################################################
# --- 1) Copy config files
if [ -d $FABRIC_CFG_PATH ]; then
    echo "orderer folder exists, cleaning it"
    rm -Rf $FABRIC_CFG_PATH
    mkdir -p $FABRIC_CFG_PATH
else
    echo "orderer folder does not exist, creating it"
    mkdir -p $FABRIC_CFG_PATH
fi
echo "################################################"
echo "using FABRIC_CFG_PATH : $FABRIC_CFG_PATH"
echo "################################################"

cp $BASE_CONFIG_FILES/configtx.yaml $FABRIC_CFG_PATH/
cp $BASE_CONFIG_FILES/orderer-config.yaml $FABRIC_CFG_PATH/orderer.yaml
#cp $BASE_CONFIG_FILES/core-orderer.yaml $FABRIC_CFG_PATH/core.yaml

################################################################################################
# --- 2) Generate-genesis.sh --- 
echo    '================ Writing the Genesis Block ================'
# Create the Genesis Block
configtxgen -profile $PROFILE -outputBlock $OUTBLOCK -channelID $CHANNELID
# profile : the profile from configtx.yaml
# outputBlock : the path to write the genesis block
# channelID  :  channel ID to use in the configtx
################################################################################################
echo "#######  Done generating the Genesis Block ###############################################"
echo "Use: ' configtxgen -inspectBlock $OUTBLOCK ' to verifiy the generated block"
echo "NOTE: check the variable FABRIC_CFG_PATH before. it must be : $FABRIC_CFG_PATH "
echo "#########################################################################################"