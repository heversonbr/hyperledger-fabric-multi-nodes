#!/bin/bash

# source all environment variables
.  /home/ubuntu/hyperledger_ws/install/fabric.env.sh

mkdir -p $HYPERLEDGER_HOME/orderer

cp $FABRIC_CONFIG_FILES/configtx.yaml $HYPERLEDGER_HOME/orderer/
cp $FABRIC_CONFIG_FILES/orderer.yaml $HYPERLEDGER_HOME/orderer/



