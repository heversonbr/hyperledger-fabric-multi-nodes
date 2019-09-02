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
cp $FABRIC_CONFIG_FILES/orderer.yaml $FABRIC_ORDERER_HOME/

# ------------------------------
# --- 2) Generate-genesis.sh --- 

PROFILE=AirlineOrdererGenesis
OUTBLOCK=./airline-genesis.block
CHANNELID=ordererchannel

echo    '================ Writing the Genesis Block ================'

configtxgen -profile $PROFILE -outputBlock $OUTBLOCK -channelID $CHANNELID
# profile : the profile from configtx.yaml
# outputBlock : the path to write the genesis block
# channelID  :  channel ID to use in the configtx

# ------------------------------
# --- 3) Register and enroll orderer --- 
# check here. 
 
# ------------------------------
# --- 4) Generate channel --- 
# Generates the orderer | generate the airline channel transaction

# export ORDERER_GENERAL_LOGLEVEL=debug
export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=$PWD

echo    '================ Writing channel ================'
configtxgen -profile AirlineChannel -outputCreateChannelTx ./airline-channel.tx -channelID airlinechannel

echo    '======= Done. Launch by executing orderer ======'

# ------------------------------
# --- 5) Sign channel tx --- 

# Sign the airline channel tx file org admins
# E.g.,   ./sign-channel-tx.sh   acme       Signs the file with acme admin certificate/key
# E.g.,   ./sign-channel-tx.sh   budget     Signs the file with budget admin certificate/key
function usage {
    echo "./sign-channel-tx.sh   ORG_NAME"
    echo "Signs the channel transaction file with identity of admin from ORG_ADMIN"
    echo "PLEASE NOTE: Signs the tx file under  orderer/multi-org-ca/airline-channel.tx "
}

if [ -z $1 ]
then
    usage
    echo 'Please provide ORG_NAME!!!'
    exit 1
else 
    ORG_NAME=$1
fi

# Set the environment variable $1 = ORG_NAME Identity=admin
source set-identity.sh 


# Variable holds path to the channel tx file
CHANNEL_TX_FILE=$PWD/../../orderer/multi-org-ca/airline-channel.tx

# Execute command to sign the tx file in place
peer channel signconfigtx -f $CHANNEL_TX_FILE

echo "====> Done. Signed file with identity $ORG_NAME/admin"
echo "====> Check size & timestamp of file $CHANNEL_TX_FILE"

# PS: The join cannot be execute without a channel created
# peer channel join -o localhost:7050 -b $PWD/../../orderer/multi-org-ca/airline-channel.tx


# ------------------------------
# --- 6) create dir 
## sudo mkdir /var/ledgers						## Etudier alternative launch.sh
## sudo chown vagrant:vagrant /var/ledgers/	## du orderer
orderer 									## ./launch.sh

# ------------------------------
# --- 7) lauch.sh
###  # Use this script for overriding ORDERER Parameters
###  export FABRIC_CFG_PATH=$PWD
###  
###  # export ORDERER_FILELEDGER_LOCATION="/var/ledgers/multi-org-ca/orderer/ledger" 
###  export ORDERER_FILELEDGER_LOCATION="/home/vagrant/ledgers/multi-org-ca/orderer/ledger" 
###  
###  mkdir -p log
###  
###  LOG_FILE=./log/orderer.log
###  
###  sudo -E orderer 2> $LOG_FILE &
###  
###  echo "===> Done.  Please check logs under   $LOG_FILE"

