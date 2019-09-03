#!/bin/bash
# Enroll identity with Fabric CA server
# sequence of commands for acme-admin
#     echo "Enrolling: acme-admin"
#     ORG_NAME="acme"
#     source setclient.sh   $ORG_NAME   admin
#     checkCopyYAML
#     fabric-ca-client enroll -u http://acme-admin:pw@localhost:7054
#     setupMSP
#
# The enroll command stores an enrollment certificate (ECert), 
# corresponding private key and CA certificate chain PEM files 
# in the subdirectories of the Fabric CA client’s msp directory. 
# You will see messages indicating where the PEM files are stored.s

usage(){
    echo "-------------------------------------------------------------"
    echo "USAGE: ./enroll_admin_and_setup_msp.sh <org_name> <ca-admin_HOSTNAME> <ca-admin_host_IP>"
    echo "   EX: ./enroll_admin_and_setup_msp.sh acme ca-admin 192.168.1.10"
    echo "-------------------------------------------------------------"
    exit
}

if [ $# -ne 3 ]; then
    usage
fi

ORG_NAME=$1
CA_ADMIN_HOSTNAME=$2
CA_SERVER_HOST_IP=$3

ADMIN_USER=$ORG_NAME-admin
ADMIN_USER_PW=pw
# path to the client certificate at the ca-server's client (?)
ADMIN_CERTS_DIR="$HYPERLEDGER_HOME/ca-client/caserver/admin/msp/signcerts"

# set ca client home
SUBDIR=$ORG_NAME/admin
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

#copy yaml
# If client YAML not found then copy the client YAML before enrolling
if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG" ]; then 
    echo "Using the existing Client $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG for $ORG_NAME admin"
else
    echo "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG not found in $FABRIC_CA_CLIENT_HOME/"
    echo "creating : mkdir -p $FABRIC_CA_CLIENT_HOME " 
    mkdir -p $FABRIC_CA_CLIENT_HOME

    echo "Copy the Client Yaml from $FABRIC_CONFIG_FILES/fabric-ca-client-config-$ORG_NAME.yaml"
    echo "cp $FABRIC_CONFIG_FILES/fabric-ca-client-config-$ORG_NAME.yaml $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG"
    cp  $FABRIC_CONFIG_FILES/fabric-ca-client-config-$ORG_NAME.yaml $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG
    echo "checking with: ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG"
    ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG
fi

# enroll
echo "Enrolling: $ORG_NAME-admin:"
# Exemple for acme:  fabric-ca-client enroll -u http://acme-admin:pw@localhost:7054
echo "fabric-ca-client enroll -u http://$ADMIN_USER:$ADMIN_USER_PW@$CA_SERVER_HOST_IP:7054"
fabric-ca-client enroll -u http://$ADMIN_USER:$ADMIN_USER_PW@$CA_SERVER_HOST_IP:7054


# Setup creates the admincerts folder and copies the admin's cert to 
# admincerts folder
# run this script from the msp hosts at the organizations



### setupMSP ### 
if [ ! -d  $FABRIC_CA_CLIENT_HOME/msp/admincerts ]; then 
    echo "Creating $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
else
    echo "$FABRIC_CA_CLIENT_HOME/msp/admincerts already exists!!!"
fi
echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"

echo "copying $ADMIN_CERTS_DIR/*  to $FABRIC_CA_CLIENT_HOME/msp/admincerts"
echo "directory $ADMIN_CERTS_DIR does not exist locally"
echo "getting admin certs using scp"
echo "scp $CA_ADMIN_HOSTNAME:$ADMIN_CERTS_DIR/* $FABRIC_CA_CLIENT_HOME/msp/admincerts"
scp $CA_ADMIN_HOSTNAME:$ADMIN_CERTS_DIR/* $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "checking with: ls $FABRIC_CA_CLIENT_HOME/msp/admincerts/"
ls $FABRIC_CA_CLIENT_HOME/msp/admincerts/

### Setup org msp (copy admin certs)
### Creates the admincerts folder and copies the admin's cert to admincerts folder"
# Set the destination as ORG folder
# source setclient.sh $ORG_NAME  admin
# not doing the set again because it is already done. 
# the original setup is made in a different script, 
# that's why there is a setclient here. we dont need it.

# Path to the CA certificate
ROOT_CA_CERTIFICATE=$FABRIC_CA_SERVER_HOME/ca-cert.pem
# Parent folder for the MSP folder
DESTINATION_CLIENT_HOME="$FABRIC_CA_CLIENT_HOME/.."

# Create the MSP subfolders
echo "create $DESTINATION_CLIENT_HOME/msp subfolders"
mkdir -p $DESTINATION_CLIENT_HOME/msp/admincerts 
mkdir -p $DESTINATION_CLIENT_HOME/msp/cacerts 
mkdir -p $DESTINATION_CLIENT_HOME/msp/keystore

## Copy the Root CA Cert
#cp $ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts
## Copy the admin certs - ORG admin is the admin for the specified Org
#cp $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts 

echo "scp $CA_ADMIN_HOSTNAME:$ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts"
scp $CA_ADMIN_HOSTNAME:$ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts
# Copy the admin certs - ORG admin is the admin for the specified Org
echo "cp $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts"
cp $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts 

echo "--------------------------------------------------------"
echo "Created MSP for org: $ORG_NAME at: $DESTINATION_CLIENT_HOME"
echo "-------------- Listing Identities ----------------------"
fabric-ca-client identity list
echo "--------------------------------------------------------"