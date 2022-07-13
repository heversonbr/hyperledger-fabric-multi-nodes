#!/bin/bash

# Sets the FABRIC_CA_CLIENT_HOME based on (a) org (b) enrollment ID
# Sets the home folder for the msp client

function usage {
    echo    "-------------------------------------------------------------------"
    echo    " Sets the FABRIC_CA_CLIENT_HOME based on (a) org (b) enrollment ID "
    echo    " USAGE: .  ./set-ca-client.sh ORG-Name Enrollment-ID"
    echo    "   ex:  .  ./set-ca-client.sh org1 admin            "
    echo    "-------------------------------------------------------------------"
    echo    "  the . before ./ is required to source the file"        
    echo    "  current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
    echo    "-------------------------------------------------------------------"
    exit
}

if [ $# -ne 2 ]; then
    usage
fi

if [ "$0" = "./set-ca-client.sh" ]
then
    echo "Did you use the . before ./set-ca-client.sh? "
    exit 1
fi

echo "current FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"
echo "received [org]: $1  and [identity]: $2"
export FABRIC_CA_CLIENT_HOME=$BASE_FABRIC_CA_CLIENT_HOME/$1/$2
echo "now FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"