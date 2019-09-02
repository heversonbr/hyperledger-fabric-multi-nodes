
# Variables used for hyperledger installation
export DEBIAN_FRONTEND=noninteractive   # https://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory

export FABRIC_USER=ubuntu
export HYPERLEDGER_HOME=/home/$FABRIC_USER/hyperledger_ws
export GOROOT=/usr/local/go
export GOPATH=$HYPERLEDGER_HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HYPERLEDGER_HOME/bin

export FABRIC_VERSION=1.4.0              
export CA_VERSION=1.4.0             
export THIRDPARTY_IMAGE_VERSION=0.4.15  

export FABRIC_CONFIG_FILES=$HYPERLEDGER_HOME/config_files 

export FABRIC_CA_SERVER_HOME=$HYPERLEDGER_HOME/ca-server
export FABRIC_CA_CLIENT_HOME=$HYPERLEDGER_HOME/ca-client


export FABRIC_CA_SERVER_CONFIG=fabric-ca-server-config.yaml
export FABRIC_CA_CLIENT_CONFIG=fabric-ca-client-config.yaml

export FABRIC_CA_SERVER_LOG=$FABRIC_CA_SERVER_HOME/ca-server.log


# ORDERER
 
# next 3 variables come from generate-genesis.sh
# export ORDERER_GENERAL_LOGLEVEL=debug
export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=$HYPERLEDGER_HOME/orderer
# my variables
export FABRIC_ORDERER_HOME=$FABRIC_CFG_PATH
export ORDERER_FILELEDGER_LOCATION="$FABRIC_ORDERER_HOME/ledger"


