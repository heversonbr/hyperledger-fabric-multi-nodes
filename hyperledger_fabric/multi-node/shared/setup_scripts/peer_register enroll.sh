# Creates/Enrolls the Peer's identity + Sets up MSP for peer
# Script needs to be executed for the peers setup
# PS: Since Register (step 1) can happen only once - ignore register error if you run script multiple times
# NOTE: The identity performing the register request must be currently enrolled

usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./peer_register_enroll.sh <peer_name> <peer_pw> <org_name>"
    echo "   ex: ./peer_register_enroll.sh peer1 pw bcom"
    echo "------------------------------------------------------------------------"
    exit
}


if [ $# -ne 3 ]; then
    usage
fi

PEER_NAME=$1
PEER_PW=$2
ORG_NAME=$3


TYPE=peer
CA_SERVER_HOST_IP=192.168.1.10


# Identity of the peer must be created by the admin from the organization
IDENTITY="admin"

# sets the FABRIC_CA_CLIENT_HOME 
CA_CLIENT_FOLDER="../ca-client/$ORG_NAME"
echo "current CA_CLIENT_FOLDER= $CA_CLIENT_FOLDER"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
echo "now CA_CLIENT_FOLDER= $CA_CLIENT_FOLDER"
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

# Step-1  Org admin registers the identity
echo "#####################################################"
echo "# Registering peer $PEER_NAME with $ORG_NAME-admin"
echo "#####################################################"
echo "using FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME to register: "
echo "fabric-ca-client register --id.type $TYPE --id.name $PEER_NAME --id.secret $PEER_PW --id.affiliation $ORG_NAME "
fabric-ca-client register --id.type $TYPE --id.name $PEER_NAME --id.secret $PEER_PW --id.affiliation $ORG_NAME 
# NOTE: shouldn't we use the attributes here? :  --id.attrs $ATTRIBUTES   with ATTRIBUTES='"hf.Registrar.Roles=peer"'
echo "======Completed: Step 1 : Registered peer (can be done only once)===="

# Set the FABRIC_CA_CLIENT_HOME for peer
IDENTITY=$PEER_NAME
# setFabricCaClientHome
CA_CLIENT_FOLDER="../ca-client/$ORG_NAME"
echo "current CA_CLIENT_FOLDER= $CA_CLIENT_FOLDER"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
echo "now CA_CLIENT_FOLDER= $CA_CLIENT_FOLDER"

# Step-2 Copies the YAML file for CSR setup
# original from checkCopyYAML: 
# SETUP_CONFIG_CLIENT_YAML=="../../setup/config/multi-org-ca/yaml.0/identities/$ORG_NAME/$PEER_NAME/fabric-ca-client-config.yaml"  
SOURCE_CONFIG_CLIENT_YAML="$BASE_CONFIG_FILES/fabric-ca-client-config-peer1-bcom-identity.yaml"

if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG" ]; then 
    echo "Using the existing Client $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG for $ORG_NAME admin"
else
    echo "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG not found in $FABRIC_CA_CLIENT_HOME/"
    echo "creating : mkdir -p $FABRIC_CA_CLIENT_HOME " 
    mkdir -p $FABRIC_CA_CLIENT_HOME

    echo "Copy the Client Yaml from $SOURCE_CONFIG_CLIENT_YAML"
    echo "cp $SOURCE_CONFIG_CLIENT_YAML $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG"
    cp $SOURCE_CONFIG_CLIENT_YAML $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG

    echo "checking with: ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG"
    ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG
fi
echo "======Completed: Step 2 : Copy Check Orderer Client YAML=========="


# Step-3 Peer identity is enrolled
# Admin will  enroll the peer identity. The MSP will be written in the 
# FABRIC_CA_CLIENT_HOME
echo "#####################################################"
echo "# Enrolling peer $PEER_NAME"
echo "#####################################################"
echo "enrolling with: fabric-ca-client enroll -u http://$PEER_NAME:$PEER_PW@$CA_SERVER_HOST_IP:7054"
fabric-ca-client enroll -u http://$PEER_NAME:$PEER_PW@$CA_SERVER_HOST_IP:7054
echo "======Completed: Step 3 : Enrolled $PEER_NAME ========"
echo " "

# Step-4 Copy the admincerts to the appropriate folder
echo "#####################################################"
echo "# Setting up admincerts"
echo "#####################################################"
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "Copying admincerts for user $IDENTITY from $ADMIN_CLIENT_HOME/msp/signcerts/ to  $FABRIC_CA_CLIENT_HOME/msp/admincerts"
cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

echo "======Completed: Step 4 : MSP setup for the peer========"



