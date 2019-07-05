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
    echo "igual"
    export HOME="/home/$FABRIC_USER"
    echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME" 
    go get -u github.com/hyperledger/fabric-ca/cmd/...
    sudo cp $GOPATH/bin/*  /usr/local/bin
    sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin
    export HOME="/root"
else
    echo "different"
    go get -u github.com/hyperledger/fabric-ca/cmd/...
    sudo cp $GOPATH/bin/*  /usr/local/bin
    sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin
fi
echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME" 


## Document process leads to errors as it leads to pulling of master branch
# go get -u github.com/hyperledger/fabric-ca/cmd/...
# go get -u https://github.com/hyperledger/fabric-ca/tree/release-1.4/cmd

# git clone --branch release-1.3 https://github.com/hyperledger/fabric-ca.git
# rm -rf $GOPATH/src/github.com/hyperledger/fabric-ca 2> /dev/null
# mv fabric-ca  $GOPATH/src/github.com/hyperledger
# go install github.com/hyperledger/fabric-ca/cmd/...

#sudo cp $GOPATH/bin/*    /usr/local/bin

# (original) sudo cp $GOPATH/bin/*    $PWD/../bin
#sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin

### sudo rm $GOPATH/bin/* 

echo "CA-server Done."
echo "-----------------------------------------------------------------------------------------"