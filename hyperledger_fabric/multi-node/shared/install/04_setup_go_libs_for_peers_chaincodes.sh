#!/bin/bash

# source all environment variables
.  /home/ubuntu/hyperledger_ws/install/fabric.env.sh

echo "-----------------------------------------------------------------------------------------"
echo "Sets up GO libraries for fabric-peer and chaincode "
echo "-----------------------------------------------------------------------------------------"
echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME"
test -f "/bin/bash" && echo "This system has a bash shell"
echo "-----------------------------------------------------------------------------------------"

# Sets up GO libraries for fabric-peer and chaincode
if [ $HOME = "/root" ]; then
    echo $HOME
    export HOME="/home/$FABRIC_USER"
    echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME"
    #go get github.com/hyperledger/fabric/core/chaincode/shim
    #go get github.com/hyperledger/fabric/protos/peer
    # path changed dec/2019
    go get github.com/hyperledger/fabric-chaincode-go/shim
    go get github.com/hyperledger/fabric-protos-go
    #sudo cp $GOPATH/bin/*  /usr/local/bin
    #sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin
    export HOME="/root"
else
    echo $HOME
    echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME"
    #go get github.com/hyperledger/fabric/core/chaincode/shim
    #go get github.com/hyperledger/fabric/protos/peer
    # path changed dec/2019
    go get github.com/hyperledger/fabric-chaincode-go/shim
    go get github.com/hyperledger/fabric-protos-go
    #sudo cp $GOPATH/bin/*  /usr/local/bin
    #sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin
fi

sudo chown -R ubuntu:ubuntu $HYPERLEDGER_HOME/go
sudo chown -R ubuntu:ubuntu /home/ubuntu/.cache/go-build/

## Document process leads to errors as it leads to pulling of master branch
# go get -u github.com/hyperledger/fabric-ca/cmd/...
# go get -u https://github.com/hyperledger/fabric-ca/tree/release-1.4/cmd
# (original) sudo cp $GOPATH/bin/*    $PWD/../bin
# sudo cp $GOPATH/bin/*  $HYPERLEDGER_HOME/bin
### sudo rm $GOPATH/bin/*
echo "-----------------------------------------------------------------------------------------"
echo "Done."
echo "-----------------------------------------------------------------------------------------"
