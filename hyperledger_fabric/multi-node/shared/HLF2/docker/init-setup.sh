#!/bin/bash

DOCK_FOLDER=$PWD

echo    "====>Cleanup the earlier runs"
./clean.sh all

echo    "====>Generating the crypto"
cd config
cryptogen generate --config=crypto-config.yaml

echo    "====>Generating the genesis block"
export FABRIC_CFG_PATH=$PWD
configtxgen -outputBlock  ./orderer/airlinegenesis.block -channelID ordererchannel  -profile AirlineOrdererGenesis

echo    "====>Generating the channel create tx"
configtxgen -outputCreateChannelTx  airlinechannel.tx -channelID airlinechannel  -profile AirlineChannel

# Back to docker foder
cd $DOCK_FOLDER

echo    "====>Launching the containers"
./launch.sh

echo    "====>Setting up anchor peers for Acme & Budget"
bins/run-all.sh

echo    "===Done==="