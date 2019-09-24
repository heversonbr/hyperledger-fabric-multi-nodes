#!/bin/bash

echo "FABRIC_CFG_PATH: $FABRIC_CFG_PATH"
export ORDERER_FILELEDGER_LOCATION="$FABRIC_CFG_PATH/ledgers/ledger" 

if [ ! -d /var/ledgers ]; then
   echo "/var/ledgers does not exist, creating it"
   sudo mkdir /var/ledgers
fi
sudo chown ubuntu:ubuntu /var/ledgers/

if [ ! -d $FABRIC_CFG_PATH ]; then
   echo "$FABRIC_CFG_PATH does not exist, creating it"
   mkdir $FABRIC_CFG_PATH
fi
cd $FABRIC_CFG_PATH

if [ ! -f $FABRIC_CFG_PATH/configtx.yaml ]; then 
    echo "$FABRIC_CFG_PATH/configtx.yaml not found. copying from $BASE_CONFIG_FILES"
    cp $BASE_CONFIG_FILES/configtx.yaml $FABRIC_CFG_PATH/
fi 

if [ ! -f $FABRIC_CFG_PATH/orderer.yaml ]; then 
    echo "$FABRIC_CFG_PATH/orderer.yaml not found. copying from $BASE_CONFIG_FILES"
   cp $BASE_CONFIG_FILES/orderer-config.yaml $FABRIC_CFG_PATH/orderer.yaml
fi 

if [ ! -f $FABRIC_CFG_PATH/core.yaml ]; then 
    echo "$FABRIC_CFG_PATH/core.yaml not found. copying from $BASE_CONFIG_FILES"
    cp $BASE_CONFIG_FILES/core-orderer-node.yaml $FABRIC_CFG_PATH/core.yaml
fi 

# check for genesis block
GENESIS_BLK_NAME=my_genesis.block
echo "#######################################################################"
echo "getting GENESIS_BLK_NAME from orderer admin using scp"
echo "scp ubuntu@msp-admin-orderer:$FABRIC_CFG_PATH/$GENESIS_BLK_NAME $FABRIC_CFG_PATH"
scp ubuntu@msp-admin-orderer:$FABRIC_CFG_PATH/$GENESIS_BLK_NAME $FABRIC_CFG_PATH
ls $GENESIS_BLK_NAME
if [ ! -f $FABRIC_CFG_PATH/$GENESIS_BLK_NAME ]; then
    echo "$GENESIS_BLK_NAME not found."
else 
    echo "file $GENESIS_BLK_NAME found at $FABRIC_CFG_PATH "
fi

ORDERER_LOG=$FABRIC_CFG_PATH/orderer.log

#sudo -E orderer 2> $ORDERER_LOG &
orderer 2> $ORDERER_LOG &

echo "===> Done. Please check logs under $ORDERER_LOG"