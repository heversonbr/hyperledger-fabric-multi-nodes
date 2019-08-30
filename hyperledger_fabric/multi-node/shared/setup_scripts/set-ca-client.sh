#!/bin/bash
## Sets the FABRIC_CA_CLIENT_HOME based on (a) org (b) enrollment ID
#
#function usage {
#    echo    "-----------------------------------------------"
#    echo    "USAGE: .  ./set-ca-client.sh ORG-Name Enrollment-ID"
#    echo    "   ex: .  ./set-ca-client.sh acme admin            "
#    echo    "-----------------------------------------------"
#    echo "the . before ./ is required to source the file"        
#    echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
#    echo    "-----------------------------------------------"
#}
#
#if [ -z $1 ];
#then
#    usage
#    echo   "Provide ORG-Name & enrollment ID"
#    exit 1
#fi
#
#if [ -z $2 ];
#then
#    usage
#    echo   "Please provide enrollment ID"
#    exit 1
#fi
#
#if [ "$0" = "./set-ca-client.sh" ]
#then
#    echo "Did you use the . before ./set-ca-client.sh? "
#    exit 1
#fi
#
#echo "current FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"
#echo "received : [$1] and [$2]"
#export FABRIC_CA_CLIENT_HOME=$HYPERLEDGER_HOME/ca-client/$1/$2
#echo "now FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"
#TODO: to fix it.!

# Sets the home folder for the client
# fabric-ca-client looks for this environment vars 
function usage {
    echo 'To switch the client user folder'
    echo 'Usage:   ./setclientuser.sh  <user  default=admin> '
}

if [ -z "$1" ];
then
    USER="admin"
else
    USER=$1
fi
echo "current FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$HYPERLEDGER_HOME/ca-client/$USER
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
echo "now FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"

