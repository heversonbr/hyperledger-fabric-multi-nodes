#!/bin/bash

# source all environment variables
.  /home/ubuntu/hyperledger_ws/install/fabric.env.sh

echo "-----------------------------------------------------------------------------------------"
echo "Installing CA-server..."

# Sets up the fabric-ca-server & fabric-ca-client
sudo apt install -y libtool libltdl-dev


# Document process leads to errors as it leads to pulling of master branch
go get -u github.com/hyperledger/fabric-ca/cmd/...
# go get -u https://github.com/hyperledger/fabric-ca/tree/release-1.4/cmd

# git clone --branch release-1.3 https://github.com/hyperledger/fabric-ca.git
# rm -rf $GOPATH/src/github.com/hyperledger/fabric-ca 2> /dev/null
# mv fabric-ca  $GOPATH/src/github.com/hyperledger
# go install github.com/hyperledger/fabric-ca/cmd/...

sudo cp $GOPATH/bin/*    /usr/local/bin

# (original) sudo cp $GOPATH/bin/*    $PWD/../bin
sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin

### sudo rm $GOPATH/bin/* 

echo "CA-server Done."