#!/bin/bash

# the example below show what we do to enroll a user jdoe
# . ./setclient.sh acme jdoe
# fabric-ca-client enroll -u http://jdoe:pw@192.168.1.10:7054
# ./add-admincerts.sh acme jdoe


usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./enroll_user.sh <org> <user> <user_pass> "
    echo "   ex: ./enroll_user.sh acme jdoe pw"
    echo "------------------------------------------------------------------------"
    exit
}

if [ $# -ne 3 ]; then
    usage
fi

ORG=$1
USER=$2
USER_PW=$3

CA_SERVER_HOST=192.168.1.10
echo "org: $ORG, user: $USER"

#. set-ca-client.sh $ORG_NAME $USER
SUBDIR=$ORG/$USER
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
BASE=$FABRIC_CA_CLIENT_HOME
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

fabric-ca-client enroll -u http://$USER:$USER_PW@$CA_SERVER_HOST:7054


# ./add-admincerts.sh $ORG_NAME $USER
# Create the destination cliet home folder path
# source set-ca-client.sh $ORG_NAME  $ENROLLMENT_ID
echo "set DESTINATION_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
DESTINATION_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

# Set the client home folder to admin's client home folder
# source set-ca-client.sh $ORG_NAME  admin
SUBDIR=$ORG/admin
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
echo "current BASE=$BASE"
echo "set FABRIC_CA_CLIENT_HOME=$BASE/$SUBDIR"
export FABRIC_CA_CLIENT_HOME=$BASE/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"


# Create the msp/admincerts folder if its not there
echo "Create the msp/admincerts folder: mkdir -p $DESTINATION_CLIENT_HOME/msp/admincerts"
mkdir -p $DESTINATION_CLIENT_HOME/msp/admincerts

# Copy admin's signcerts to specified identity's admincerts
echo "Cooy admin's signcerts to identity's admincerts"
echo "cp  $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts"
cp  $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts
echo "---------------------------------------------------------------"
echo "-------------END enroll and add admin certs -------------------"
echo "---------------------------------------------------------------"
echo "------------------Listing Identities --------------------------"
fabric-ca-client identity list
echo "---------------------------------------------------------------"
