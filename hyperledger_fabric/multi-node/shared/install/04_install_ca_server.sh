#!/bin/bash

# source all environment variables
.  /home/ubuntu/hyperledger_ws/install/fabric.env.sh

echo "-----------------------------------------------------------------------------------------"
echo "Installing CA-server..."
echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME" 
test -f "/bin/bash" && echo "This system has a bash shell"
echo "-----------------------------------------------------------------------------------------"
# Sets up the fabric-ca-server & fabric-ca-client
sudo apt install -y libtool libltdl-dev

if [ $HOME = "/root" ]; then
    echo $HOME
    export HOME="/home/$FABRIC_USER"
    echo "[install_04_ca_server.sh] USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME" 
    go get -u github.com/hyperledger/fabric-ca/cmd/...
    sudo cp $GOPATH/bin/*  /usr/local/bin
    sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin
    export HOME="/root"
else
    echo $HOME
    echo "[install_04_ca_server.sh] USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME" 
    go get -u github.com/hyperledger/fabric-ca/cmd/...
    sudo cp $GOPATH/bin/*  /usr/local/bin
    sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin
fi

sudo chown -R ubuntu:ubuntu $HYPERLEDGER_HOME/go
sudo chown -R ubuntu:ubuntu $HYPERLEDGER_HOME/bin

## Document process leads to errors as it leads to pulling of master branch
# go get -u github.com/hyperledger/fabric-ca/cmd/...
# go get -u https://github.com/hyperledger/fabric-ca/tree/release-1.4/cmd
# (original) sudo cp $GOPATH/bin/*    $PWD/../bin
# sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin
### sudo rm $GOPATH/bin/* 

echo "CA-server Done."
echo "-----------------------------------------------------------------------------------------"