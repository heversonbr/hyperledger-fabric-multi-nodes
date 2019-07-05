
# Variables used for hyperledger installation
export DEBIAN_FRONTEND=noninteractive   # https://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory

export FABRIC_USER=ubuntu
export HYPERLEDGER_HOME=/home/$FABRIC_USER/hyperledger_ws
export GOROOT=/usr/local/go
export GOPATH=$HYPERLEDGER_HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export FABRIC_VERSION=1.4.0              
export CA_VERSION=1.4.0             
export THIRDPARTY_IMAGE_VERSION=0.4.15  



