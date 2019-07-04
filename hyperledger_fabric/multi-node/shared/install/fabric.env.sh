
# Variables used for hyperledger installation
export FABRIC_USER=ubuntu
export HYPERLEDGER_HOME=/home/$FABRIC_USER/hyperledger_ws
export GOROOT=/usr/local/go
export GOPATH=$HYPERLEDGER_HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export FABRIC_VERSION=1.4.1              
export CA_VERSION=1.4.1                 
export THIRDPARTY_IMAGE_VERSION=0.4.15  


