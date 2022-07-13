#!/bin/bash

# Enroll the bootstrap admin identity for the server
# The enroll command stores an enrollment certificate (ECert), 
# corresponding private key and CA certificate chain PEM files 
# in the subdirectories of the Fabric CA client’s msp directory.

CA_SERVER_HOST_IP=192.168.1.10
ADMIN_USER=admin
ADMIN_PASS=pw



echo "-----------------------------------------------------------------------------------------"
echo "Enrolling bootstrap Identity"
echo "-----------------------------------------------------------------------------------------"

################################################################################################
SUBDIR=caserver/admin

. ./set-ca-client.sh  caserver admin
echo "checking FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"

# previous without set-ca-client.sh: 
# echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
# export FABRIC_CA_CLIENT_HOME=$BASE_FABRIC_CA_CLIENT_HOME/$SUBDIR
# cho "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

################################################################################################
if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE" ]; then
    echo "Using client YAML: $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"
else
    echo "File [$FABRIC_CA_CLIENT_CONFIG_FILE] not found in [$FABRIC_CA_CLIENT_HOME/]"
    echo "mkdir -p $FABRIC_CA_CLIENT_HOME"
    mkdir -p $FABRIC_CA_CLIENT_HOME
    echo "Copying $BASE_CONFIG_FILES/$FABRIC_CA_CLIENT_CONFIG_FILE to $FABRIC_CA_CLIENT_HOME"
    cp  $BASE_CONFIG_FILES/$FABRIC_CA_CLIENT_CONFIG_FILE $FABRIC_CA_CLIENT_HOME/
fi
################################################################################################

echo "Enrolling bootstrap Identity (ca-client) with: $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"

echo "fabric-ca-client enroll -u http://$ADMIN_USER:$ADMIN_PASS@$CA_SERVER_HOST_IP:7054"
fabric-ca-client enroll -u http://$ADMIN_USER:$ADMIN_PASS@$CA_SERVER_HOST_IP:7054

echo "-------------- showing identities ----------------------"
fabric-ca-client identity list
echo "--------------------------------------------------------"

################################################################################################
# Notes: 
# The enroll command stores an enrollment certificate (ECert), 
# corresponding private key and CA certificate chain PEM files 
# in the subdirectories of the Fabric CA client’s msp directory. 
# You will see messages indicating where the PEM files are stored.