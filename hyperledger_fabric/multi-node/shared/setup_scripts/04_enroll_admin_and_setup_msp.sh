#!/bin/bash
# Enroll identity with Fabric CA server
# The enroll command stores an enrollment certificate (ECert), 
# corresponding private key and CA certificate chain PEM files 
# in the subdirectories of the Fabric CA client’s msp directory. 
# You will see messages indicating where the PEM files are stored.s

usage(){
    echo "-------------------------------------------------------------"
    echo "USAGE: ./04_enroll_admin_and_setup_msp.sh <org_name> <ca-admin_HOSTNAME> <ca-admin_host_IP>"
    echo "   EX: ./04_enroll_admin_and_setup_msp.sh bcom    msp-root-bcom 192.168.1.10"
    echo "   EX: ./04_enroll_admin_and_setup_msp.sh orange  msp-root-bcom 192.168.1.10"
    echo "   EX: ./04_enroll_admin_and_setup_msp.sh orderer msp-root-bcom 192.168.1.10"
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

# path to the client certificate at the ca-server admin: 
ADMIN_CERTS_DIR="$BASE_FABRIC_CA_CLIENT_HOME/caserver/admin/msp/signcerts"

SOURCE_CA_CLIENT_CONFIG_FILE="fabric-ca-client-config-$ORG_NAME-admin.yaml"

# set ca client to org-admin
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/admin
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

# Copy yaml
# If client YAML not found then copy the client YAML before enrolling
if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE" ]; then 
    echo "Using the existing Client $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE for $ORG_NAME admin"
else
    echo "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE not found in $FABRIC_CA_CLIENT_HOME/"
    echo "creating : mkdir -p $FABRIC_CA_CLIENT_HOME " 
    mkdir -p $FABRIC_CA_CLIENT_HOME

    echo "Copy $BASE_CONFIG_FILES/$SOURCE_CA_CLIENT_CONFIG_FILE  to $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"
    cp  $BASE_CONFIG_FILES/$SOURCE_CA_CLIENT_CONFIG_FILE  $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE
    
    echo "checking with: ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"
    ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE
    if [ `echo $?` = 0 ]; then 
        echo "File $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE found."; 
    else 
        echo "ERROR: file $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE not found!"; 
        exit
    fi
fi

# enroll admin
echo "###################################"
echo "# Enrolling: $ORG_NAME-admin:"
echo "###################################"
# Exemple for acme:  fabric-ca-client enroll -u http://acme-admin:pw@localhost:7054
echo "fabric-ca-client enroll -u http://$ADMIN_USER:$ADMIN_USER_PW@$CA_SERVER_HOST_IP:7054"
fabric-ca-client enroll -u http://$ADMIN_USER:$ADMIN_USER_PW@$CA_SERVER_HOST_IP:7054


# Setup creates the admincerts folder and copies the admin's cert to 
# admincerts folder
# run this script from the msp hosts at the organizations
echo "###################################"
echo "# Setting up admincerts folder"
echo "###################################"

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