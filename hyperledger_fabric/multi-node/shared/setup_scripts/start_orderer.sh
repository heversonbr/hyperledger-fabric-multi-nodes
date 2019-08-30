#!/bin/bash

usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./start_orderer.sh"
    echo "   ex: ./start_orderer.sh"
    echo "------------------------------------------------------------------------"
    exit
}

#if [ $# -ne 6 ]; then
#    usage
#fi


if [ -d $FABRIC_ORDERER_HOME ]; then
    echo "orderer folder exists, cleaning it"
    rm -Rf $FABRIC_ORDERER_HOME
    mkdir -p $FABRIC_ORDERER_HOME
else
    echo "orderer folder does not exist, creating it"
    mkdir -p $FABRIC_ORDERER_HOME
fi

cp $FABRIC_CONFIG_FILES/configtx.yaml $FABRIC_ORDERER_HOME/
cp $FABRIC_CONFIG_FILES/orderer.yaml $FABRIC_ORDERER_HOME/


# ----- from generate-genesis.sh 

PROFILE=AirlineOrdererGenesis
OUTBLOCK=./airline-genesis.block
CHANNELID=ordererchannel


# Create the Genesis Block
echo    '================ Writing the Genesis Block ================'

configtxgen -profile $PROFILE -outputBlock $OUTBLOCK -channelID $CHANNELID
# profile : the profile from configtx.yaml
# outputBlock : the path to write the genesis block
# channelID  :  channel ID to use in the configtx

# ------- register and enroll orderer
# check here. 
 

# ------- generate channel 
# Generates the orderer | generate the airline channel transaction

# export ORDERER_GENERAL_LOGLEVEL=debug
export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=$PWD

function usage {
    echo "./generate-channel-tx.sh "
    echo "     Creates the airline-channel.tx for the channel airlinechannel"
}

echo    '================ Writing airlinechannel ================'

configtxgen -profile AirlineChannel -outputCreateChannelTx ./airline-channel.tx -channelID airlinechannel



echo    '======= Done. Launch by executing orderer ======'


