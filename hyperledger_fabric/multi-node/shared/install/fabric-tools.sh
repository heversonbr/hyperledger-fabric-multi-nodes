#!/bin/bash

#  curl -sSL  https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh| bash -s 1.4.0-rc2  
echo "Downloading fabric bootstrap script"
wget https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh  -O $HYPERLEDGER_HOME/scripts/fabric-bootstrap.sh 
sudo chmod 775 $HYPERLEDGER_HOME/scripts/fabric-bootstrap.sh

