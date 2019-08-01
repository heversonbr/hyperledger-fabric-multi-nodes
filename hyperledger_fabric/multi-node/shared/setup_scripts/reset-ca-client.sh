#!/bin/bash

function usage {
    echo    "------------------------------"
    echo    "USAGE: .  ./reset-ca-client.sh"
    echo    "   ex: .  ./reset-ca-client.sh"
    echo    "------------------------------"
    echo "the . before ./ is required to source the file"        
    echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
    echo    "-----------------------------------------------"
}

if [ "$0" = "./reset-ca-client.sh" ]
then
    echo "Did you use the . before ./set-ca-client.sh? "
    usage
    exit 1
fi

echo "current FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$HYPERLEDGER_HOME/ca-client
echo "now FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"